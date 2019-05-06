class Student
  attr_accessor :id, :name, :grade

  def initialize()
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    student = Student.new()
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.batch_create(rows)
    rows.map{|row| new_from_db(row)}
  end

  def self.all
    rows = DB[:conn].execute("SELECT * FROM students;")
    batch_create(rows)
  end

  def self.find_by_name(name)
    new_from_db(DB[:conn].execute("SELECT * FROM students WHERE name = ?;", name)[0])
  end

  def self.all_students_in_grade_9
    batch_create(DB[:conn].execute("SELECT * FROM students WHERE grade = 9;"))
  end

  def self.students_below_12th_grade
    batch_create(DB[:conn].execute("SELECT * FROM students WHERE grade < 12;"))
  end

  def self.first_X_students_in_grade_10(num)
    batch_create(DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?;", num))
  end

  def self.first_student_in_grade_10
    new_from_db(DB[:conn].execute("SELECT * FROM students WHERE grade = 10;")[0])
  end

  def self.all_students_in_grade_X(grade)
    batch_create(DB[:conn].execute("SELECT * FROM students WHERE grade = ?;", grade))
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
