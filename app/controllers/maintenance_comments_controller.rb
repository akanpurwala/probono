class MaintenanceCommentsController < ApplicationController
  respond_to :html, :js
  def create
    @mr = MaintenanceRequest.find(params[:maintenance_request_id])
    @comments = @mr.maintenance_comments
    @comment = current_user.maintenance_comments.build(params[:maintenance_comment])
    @comment.maintenance_request = @mr
    @new_comment = MaintenanceComment.new
    if @comment.save
      flash[:notice] = "Your comment was created."
    else
      flash[:error] = "There was an error creating your comment. Please try again."
    end

    respond_with(@comment) do |f|
      f.html { redirect_to @mr }
    end
  end

  def destroy
    @mr = MaintenanceRequest.find(params[:maintenance_request_id])
    @comment = @mr.maintenance_comments.find(params[:id])
    if @comment.destroy
      flash[:notice] = "You have successfully deleted your comment."
    else
      flash[:error] = "There was an error deleting your comment. Please try again."
    end
    respond_with(@comment) do |f|
      f.html { redirect_to @mr }
    end
  end

end
