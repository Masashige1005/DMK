class CommunityCommentsController < ApplicationController
  def create
  	@community = Community.find(params[:community_id])
    # @songのidを含んだ状態でインスタンスを作成
    @comment = @community.community_comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      # render :indexによってapp/views/comments/index.js.erbを探す
      render :index
    end
  end

  private

  def comment_params
    params.require(:community_comment).permit(:body, :community_id, :user_id)
  end
end