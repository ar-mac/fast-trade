class ProjectsController < ApplicationController
  def update
    prog = params[:project][:progress]
    @project.update(progress: prog)
    #debugger
  end
end
