class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show update ]
  before_action :set_course

  # GET /lessons or /lessons.json


  # GET /lessons/1 or /lessons/1.json
  def show
    # pluck(:lesson_id): Sau khi truy vấn và lọc, pluck sẽ lấy ra danh sách lesson_id của các bài học mà người dùng đã hoàn thành.

    @complete_lessons = current_user.lesson_users.where(complete: true).pluck(:lesson_id)
    @course = @lesson.course
  end

  # GET /lessons/new

  # GET /lessons/1/edit

  # POST /lessons or /lessons.json

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    @lesson_user = LessonUser.find_or_create_by(user: current_user, lesson: @lesson)
    @lesson_user.update!(complete: true)
    next_lesson = @course.lessons.where("position > ?", @lesson.position).order(:position).first
    if next_lesson
      redirect_to course_lesson_path(@course, next_lesson)
    else
      redirect_to course_path(@course), notice: "You've completed the course"
    end
  end

  # DELETE /lessons/1 or /lessons/1.json

  private
    def set_course
      @course = Course.find(params[:course_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end
end
