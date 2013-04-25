class AddPrimaryKey < ActiveRecord::Migration
  def change
    EvaluationAnswer.find_by_sql("ALTER TABLE evaluation_answers ADD PRIMARY KEY (id);"); 
  end
end
