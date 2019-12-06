class CommentsController < ApplicationController
  def create
    @song = Song.find(params[:song_id])
    @comment = @song.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      render :index
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :post_id, :user_id)
    end
end
