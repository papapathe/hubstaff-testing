class TasksController < ApplicationController
  before_action :find_project
  before_action :find_task, only: %i[show update destroy]

  def index
    render json: TaskSerializer.new(@project.tasks).serialized_json
  end

  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      render json: TaskSerializer.new(@task).serialized_json
    else
      render json: {errors: @task.errors.full_messages}, status: 422
    end
  end

  def show
    render json: TaskSerializer.new(@task).serialized_json
  end

  def update
    if @task.update(task_params)
      render json: TaskSerializer.new(@task).serialized_json
    else
      render json: {errors: @task.errors.full_messages}, status: 422
    end
  end

  def destroy
    @task.destroy
    head :ok
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.permit(:name, :description)
  end
end
