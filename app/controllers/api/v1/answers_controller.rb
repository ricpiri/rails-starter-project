module Api
    module V1
        class AnswersController < Api::V1::ApiController
            before_action :doorkeeper_authorize!

            def create
                answer = Answer.new(answer_params)

                if answer.save
                    render json: answer, status: :created, location: api_v1_answers_url(answer)
                else
                    render json: answer.errors, status: :unprocessable_entity
                end
            end

            private
            
            
            def answer_params
                jsonapi = JSON.parse(request.raw_post).fetch('data')
                {
                    body: jsonapi.dig('attributes', 'body'),
                    question: Question.find(jsonapi.dig('relationships', 'question', 'data', 'id')),
                    user: current_user
                }
            end
        end
    end
end



