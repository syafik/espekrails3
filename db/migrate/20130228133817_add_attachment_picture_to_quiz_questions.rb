class AddAttachmentPictureToQuizQuestions < ActiveRecord::Migration
  def self.up
    change_table :quiz_questions do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :quiz_questions, :picture
  end
end
