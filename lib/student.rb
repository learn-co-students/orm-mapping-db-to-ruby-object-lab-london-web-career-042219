class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    return new_student
  end
  
  def self.create(table)
    return table.map { |row| self.new_from_db(row) }
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    return self.create(DB[:conn].execute("SELECT * FROM students;"))
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-query
    SELECT *
    FROM students
    WHERE students.name = ?
    LIMIT 1;
    query

    return self.create(DB[:conn].execute(sql,name)).first
  end

  def self.all_students_in_grade_9
    sql = <<-query
    SELECT *
    FROM students
    WHERE students.grade = ?;
    query

    return self.create(DB[:conn].execute(sql,9))
  end

  def self.students_below_12th_grade
    sql = <<-query
    SELECT *
    FROM students
    WHERE students.grade < ?;
    query

    return self.create(DB[:conn].execute(sql,12))
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-query
    SELECT *
    FROM students
    WHERE students.grade = 10
    LIMIT ?;
    query

    return self.create(DB[:conn].execute(sql,num))
  end

  def self.first_student_in_grade_10
    return first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-query
    SELECT *
    FROM students
    WHERE students.grade = ?;
    query

    return self.create(DB[:conn].execute(sql,grade))
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    return DB[:conn].execute(sql, self.name, self.grade)
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
