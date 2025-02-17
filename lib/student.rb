class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name_in, grade_in, id_in = nil)
    @name = name_in
    @grade = grade_in
    @id = id_in
  end

  def self.create_table
    sql = <<-SQL
        CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
      SQL
    DB[:conn].execute(sql,self.name,self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:,grade:)
    new_student = Student.new(name,grade)
    new_student.save
    new_student
  end

end
