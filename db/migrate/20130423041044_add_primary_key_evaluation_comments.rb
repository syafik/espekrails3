class AddPrimaryKeyEvaluationComments < ActiveRecord::Migration
  def change
    EvaluationComment.find_by_sql("ALTER TABLE evaluation_comments ADD PRIMARY KEY (id);");
  end
end
