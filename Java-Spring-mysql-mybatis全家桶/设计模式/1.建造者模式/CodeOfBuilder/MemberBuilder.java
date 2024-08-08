public class MemberBuilder {
    public Student StudentBuilder(String name,int age,String sex){
        Student student = new Student();
        student.setName(name);
        student.setAge(age);
        student.setSex(sex);
        return student;
    }
    public Teacher TeacherBuilder(String name,int age,String sex){
        Teacher teacher = new Teacher();
        teacher.setName(name);
        teacher.setAge(age);
        teacher.setSex(sex);
        return teacher;
    }
}
