import { createRouter, createWebHistory } from 'vue-router'

const routes = [
    {
        path: '/',
        redirect: '/Main'  // 重定向到Main主页
    },
    {
        path: '/Login',
        component: () => import('/src/pages/LoginAndRegister/Login.vue')  // 登录页
    },
    {
        path: '/Main',
        component: () => import('/src/pages/MainPage/Main.vue'),  // 员工操作页
    },
    {
        path: '/Register',
        component: () => import('/src/pages/LoginAndRegister/Register.vue')  // 注册页
    },
    {
        path: '/Blog',
        component: () => import('/src/pages/Blog/Blog.vue')  // 注册页
    },
    {
        path: '/Main',
        component: () => import('/src/pages/MainPage/Main.vue'),  // 欢迎页
        meta: { requiresAuth: true }  // 需要认证的页面
    },
    {
        path: '/AdminOperation',
        component: () => import('/src/pages/Operation/AdminOperation.vue'),  // 管理操作页
        meta: { requiresAuth: true, role: 'admin' }  // 只有管理员可以访问
    },
    {
        path: '/PersonOperation',
        component: () => import('/src/pages/Operation/PersonOperation.vue'),  // 员工操作页
        meta: { requiresAuth: true, role: 'user' }  // 只有员工可以访问
    },

    {
        path: '/SelfInformation',
        component: () => import('/src/pages/Self/SelfInformation.vue'),  // 个人信息页
        meta: { requiresAuth: true }  // 需要认证的页面
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

// 添加路由守卫来检查是否需要认证
router.beforeEach((to, from, next) => {
    const isAuthenticated = localStorage.getItem('isLoggedIn') === 'true';
    const userAuthority = localStorage.getItem('authority');

    // 检查是否已经在目标页面，避免重复跳转
    if (to.path === from.path) {
        return next();  // 如果目标路径和当前路径相同，则直接放行
    }

    if (to.meta.requiresAuth && !isAuthenticated) {
        console.log("用户未登录，重新跳转登录页面");
        alert("用户权限不足，员工请先登录账号/管理界面仅有管理员才能访问哦！员工是不可以进入的！");
        next('/Main');  // 用户未登录，跳转到首页
    } else if (to.meta.role) {
        // 检查用户角色是否满足路由权限要求
        if (userAuthority) {
            if (userAuthority === to.meta.role) {
                next();  // 用户角色符合要求，放行
            } else {
                console.log("用户权限不足，重新跳转首页页面");
                alert("用户权限不足，请您先登录");
                next('/Main');  // 用户权限不足，跳转到首页
            }
        } else {
            console.log("用户角色未设置，跳转到登录页面");
            alert("用户权限不足，请您先登录");
            next('/Login');  // 如果没有角色，跳转到登录页
        }
    } else {
        next(); // 不需要权限的页面，直接放行
    }
});




export default router
