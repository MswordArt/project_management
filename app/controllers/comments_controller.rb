class CommentsController < ApplicationController
    before_action :find_commentable
    #before_action :set_task
       
        def new
          @comment = Comment.new
        end
    
        def create
          @comment = @commentable.comments.new comment_params
          if @comment.save
            
            redirect_back fallback_location: root_path, notice: 'Your comment was successfully posted!'
            #CommentMailer.new_comment(comment).deliver
            CommentMailer.new_comment(@comment).deliver
          else
            redirect_back fallback_location: root_path, notice: "Your comment wasn't posted!"
          end
        end
    
        private
    
        def comment_params
          params.require(:comment).permit(:body, :user_id)
        end
    
        def find_commentable
          @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
          @commentable = Task.find_by_id(params[:task_id]) if params[:task_id]
          @user_id = current_user.id
        end
    



        def set_task
            @task = Task.find(params[:task_id])
          end
    end