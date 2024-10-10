class Course < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  has_many :lessons
  has_and_belongs_to_many :categories

  def first_lesson
    self.lessons.order(:position).first
  end

  def next_lesson(current_user)
    if current_user.blank?
      return self.lessons.order(:position).first
    end
    # Truy vấn lấy các bài học mà người dùng đã hoàn thành trong khóa học hiện tại (self.id là khóa học hiện tại).
    # Sử dụng includes(:lesson) để tối ưu hóa truy vấn bằng cách nạp trước các bài học liên quan.
    # Điều kiện where(complete: true) giúp lọc ra các bài học mà người dùng đã hoàn thành.
    complete_lessons = current_user.lesson_users.includes(:lesson).where(complete: true).where(lessons: { course_id: self.id })
    # Lấy các bài học mà người dùng đã bắt đầu nhưng chưa hoàn thành trong khóa học này, sắp xếp theo thứ tự position của bài học.
    started_lessons = current_user.lesson_users.includes(:lesson).where(complete: false).where(lesson: { course_id: self.id }).order(:position)

    if started_lessons.any?
      return started_lessons.first.lesson
    end

    lessons = self.lessons.where.not(id: complete_lessons.pluck(:lesson_id)).order(:position)
    if lessons.any?
      lessons.first
    else
      self.lessons.order(:position).first
    end
  end
end
