class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  def create
    @comment = current_user.comments.build(comment_params)
    @entry = Entry.find_by(id: @comment.entry_id)
    if (current_user.following?(@entry.user) || current_user?(@entry.user))
      if @comment.save
        flash[:success] = "Comment created!"
        redirect_to request.referrer || root_url
      else
        render 'static_pages/home'
      end
    else
      flash[:danger] = "Need following before comment"
      redirect_to request.referrer || root_url
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to request.referrer || root_url
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :entry_id)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
