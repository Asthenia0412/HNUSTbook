public class Main{
    public static void main(String[] args){
        MemberBuilder builder = new MemberBuilder();
        Student student = builder.StudentBuilder("张三",18,"男");
        Teacher teacher = builder.TeacherBuilder("李四",68,"女");
        System.out.println(student+""+teacher);
    }
}