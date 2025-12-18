package com.zyd.blog.controller;

import com.zyd.blog.business.entity.User;
import com.zyd.blog.business.service.SysUserService;
import com.zyd.blog.util.PasswordUtil;
import com.zyd.blog.util.ResultUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class PassportController {

    @Autowired
    private SysUserService userService;

    @GetMapping("/login")
    public String loginPage() {
        return "passport/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "passport/register";
    }

    /**
     * 处理登录：支持明文和密文双重匹配
     */
    @PostMapping("/login")
    @ResponseBody
    public Object doLogin(String username, String password, HttpSession session) {
        User loginUser = null;
        // 1. 先查出所有用户 (OneBlog Service层通常没有直接根据用户名查的方法)
        List<User> allUsers = userService.listAll();

        for (User u : allUsers) {
            // 先匹配用户名
            if (u.getUsername().equals(username)) {
                // 找到用户了，开始校验密码
                boolean isMatch = false;

                // 方式A: 直接比对明文 (满足你现在的需求)
                if (u.getPassword().equals(password)) {
                    isMatch = true;
                }
                // 方式B: 尝试加密比对 (兼容旧的管理员账号)
                else {
                    try {
                        // 这里的 PasswordUtil 是 OneBlog 自带的，需要 encrypt(密码, 盐值/用户名)
                        // 如果这行爆红，说明包名不对，请重新 Alt+Enter 导入 PasswordUtil
                        String encryptPwd = PasswordUtil.encrypt(password, username);
                        if (u.getPassword().equals(encryptPwd)) {
                            isMatch = true;
                        }
                    } catch (Exception e) {
                        // 忽略加密错误
                    }
                }

                if (isMatch) {
                    loginUser = u;
                    break;
                }
            }
        }

        if (loginUser != null) {
            session.setAttribute("user", loginUser);
            return ResultUtil.success("登录成功");
        } else {
            return ResultUtil.error("用户名或密码错误");
        }
    }

    /**
     * 处理注册：直接存明文密码
     */
    @PostMapping("/register")
    @ResponseBody
    public Object doRegister(String username, String password, String nickname) {
        // 简单的查重逻辑
        List<User> allUsers = userService.listAll();
        for (User u : allUsers) {
            if (u.getUsername().equals(username)) {
                return ResultUtil.error("用户名已存在");
            }
        }

        User user = new User();
        user.setUsername(username);
        // 【关键】直接存明文，不加密
        user.setPassword(password);
        user.setNickname(nickname);
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());
        user.setStatus(1);
        user.setUserType("USER");

        userService.insert(user);

        return ResultUtil.success("注册成功，请登录");
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("user");
        return "redirect:/";
    }
}