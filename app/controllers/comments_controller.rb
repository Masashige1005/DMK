# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @song = Song.find(params[:song_id])
    # @songのidを含んだ状態でインスタンスを作成
    @comment = @song.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      # render :indexによってapp/views/comments/index.js.erbを探す
      render :index
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :user_id)
  end
end
