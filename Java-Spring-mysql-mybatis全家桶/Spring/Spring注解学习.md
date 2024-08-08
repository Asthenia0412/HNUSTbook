 * 1.扫描的四种实现方式：
 *         A.@ComponentScan(value="com.xxxx.test")
 *         B.@Bean在配置类中添加 写方法
 *         C.@Import({Department.class, Employee.class, MyImportSelector.class}) 作用在配置类上
 *         D.BeanFactory注册
 * 2.Bean的生命周期
 *          A.init-method在xml中的实现与@Bean(initMethod="");
 *          B.destroy-method在xml中的实现与@Bean(destroyMethod="");
 *          C.@PostConstruct 修饰方法-表示在Servlet创建后工作
 *          D.@PreDestroy 表示在Servlet卸载前工作
 * 3.DI的实现
 *          A.XML方式实现：<bean> <property name="" value="">
 *          B.@Autowired实现:@Resource @Qualifer @Primary @Inject
 *          C.@Value("${前提是有Proertysource}") @Value("#{直接注入值}")