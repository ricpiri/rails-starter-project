module Api
    module V1
        class QuestionsController < Api::V1::ApiController
            before_action :doorkeeper_authorize!, only: [:show, :create]
            QUESTIONS_PER_PAGE = 5

            def index
                filter = params[:filter]
                page = params[:page].to_i || 1

                questions = Question.all
                questions = questions.where('LOWER(questions.tags) LIKE LOWER(:search)', search: "%#{filter}%") unless filter.empty?
                questions = questions.order(:created_at)
                questions = questions.page(page).per(QUESTIONS_PER_PAGE)

                render json: questions,
                    meta: { page: { pages: questions.total_pages } }
            end

            def show
                question = Question.friendly.find(params[:id])
                question.views = question.views + 1
                question.save(touch: false)

                render json: question, include: %i[user answers]
            end

            def create
                @question = current_user.questions.new(question_params)

                if @question.save
                    render json: @question, status: :created, location: api_v1_question_url(@question)
                else
                    render json: @question.errors, status: :unprocessable_entity
                end
            end

            def update
                puts params.inspect
                question = Question.find(params[:id])

                if question.save(question_params)
                    render json: @question, status: :ok, location: api_v1_question_url(@question)
                else
                    render json: @question.errors, status: :not_found
                end
            end

            def update
                question = Question.find(params[:id])

                jsonapi = JSON.parse(request.raw_post).fetch('data')

                question_params = {
                    title: jsonapi.dig('attributes', 'title'),
                    description: jsonapi.dig('attributes', 'description'),
                    tags: jsonapi.dig('attributes', 'tags')
                }

                if question.save(question_params)
                    render json: @question, status: :ok
                else
                    render json: @question.errors, status: :not_found
                end
            end


            def destroy
                question = Question.find(params[:id])
                if current_user == question.user
                    question.destroy!
                    render json: @question, status: :ok
                else
                    render json: @question, status: :unprocessable_entity
                end
            end

            private
            
            
            def question_params
                params.require(:data).require(:attributes).permit(:title, :slug, :description, :tags)
            end
        end
    end
end
