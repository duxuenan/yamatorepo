# AGENTS.md - 大贺运输新系统开发指南

## 项目概述
大贺运输新系统是一个基于前后端分离架构的运输管理系统，采用React + Spring Boot技术栈。

## 技术栈
- **前端**: React 18.x + TypeScript + Ant Design + Zustand + React Router 6.x
- **后端**: Spring Boot 3.x + Java 17 + Spring Security + PostgreSQL + Redis
- **数据库**: PostgreSQL 15.x
- **缓存**: Redis 7.x
- **认证**: JWT (Bearer Token)

## 构建和开发命令

### 前端开发
```bash
# 安装依赖
npm install

# 开发服务器
npm run dev

# 构建生产版本
npm run build

# 类型检查
npm run type-check

# 代码检查
npm run lint

# 运行测试
npm run test

# 运行单个测试
npm test -- --testPathPattern=组件名或文件名
```

### 后端开发
```bash
# 使用Maven构建
mvn clean compile

# 运行测试
mvn test

# 运行单个测试类
mvn test -Dtest=ClassName

# 运行单个测试方法
mvn test -Dtest=ClassName#methodName

# 打包
mvn clean package

# 运行应用
mvn spring-boot:run

# 代码检查
mvn checkstyle:check
```

## 代码风格指南

### 前端代码规范

#### 文件结构
```
frontend/
├── src/
│   ├── components/           # 公共组件
│   │   ├── Layout/          # 布局组件
│   │   ├── Navigation/      # 导航组件
│   │   └── Common/          # 通用组件
│   ├── pages/               # 页面组件（按b0, b1, p0等分类）
│   ├── hooks/               # 自定义Hooks
│   ├── stores/              # Zustand状态管理
│   ├── services/            # API服务层
│   ├── types/               # TypeScript类型定义
│   ├── utils/               # 工具函数
│   ├── router/              # 路由配置
│   └── styles/              # 全局样式
```

#### 命名约定
- **组件**: PascalCase (如 `SideMenu.tsx`, `Header.tsx`)
- **函数/变量**: camelCase (如 `getUserData`, `isLoading`)
- **常量**: UPPER_SNAKE_CASE (如 `API_BASE_URL`, `MAX_RETRY_COUNT`)
- **接口/类型**: PascalCase (如 `User`, `ApiResponse<T>`)
- **文件**: kebab-case (如 `user-service.ts`, `auth-guard.tsx`)

#### 导入顺序
```typescript
// 1. React和第三方库
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button, Table, Modal } from 'antd';

// 2. 项目内部模块
import { useAuthStore } from '@/stores/authStore';
import { userService } from '@/services/userService';
import type { User, ApiResponse } from '@/types';

// 3. 样式和资源
import './styles.css';
import logo from '@/assets/logo.png';
```

#### TypeScript规范
- 使用严格模式 (`strict: true`)
- 优先使用`interface`定义对象类型
- 使用`type`定义联合类型、交叉类型和别名
- 避免使用`any`类型，使用`unknown`或具体类型
- 组件Props必须定义类型

```typescript
// 正确示例
interface UserProps {
  userId: string;
  userName: string;
  role: 'admin' | 'user' | 'guest';
  onUpdate?: (user: User) => void;
}

const UserComponent: React.FC<UserProps> = ({ userId, userName, role, onUpdate }) => {
  // 组件实现
};
```

#### 错误处理
```typescript
// API调用错误处理
try {
  const data = await userService.getUser(userId);
  // 处理成功
} catch (error) {
  if (error instanceof ApiError) {
    message.error(error.message);
  } else {
    message.error('请求失败，请稍后重试');
  }
  // 记录错误日志
  console.error('获取用户失败:', error);
}
```

### 后端代码规范

#### 项目结构
```
backend/
├── src/main/java/com/yamato/base/
│   ├── config/              # 配置类
│   ├── common/              # 公共模块
│   │   ├── constant/        # 常量
│   │   ├── result/          # 返回结果
│   │   ├── exception/       # 异常处理
│   │   ├── utils/           # 工具类
│   │   └── annotation/      # 自定义注解
│   ├── security/            # 安全模块
│   └── modules/             # 业务模块
│       ├── screen/          # 画面模块
│       │   ├── controller/
│       │   ├── service/
│       │   ├── repository/
│       │   ├── entity/
│       │   └── dto/
│       └── user/            # 用户模块
```

#### 命名约定
- **类名**: PascalCase (如 `UserController`, `UserService`)
- **方法名**: camelCase (如 `getUserById`, `createUser`)
- **变量名**: camelCase (如 `userName`, `isActive`)
- **常量**: UPPER_SNAKE_CASE (如 `MAX_RETRY_COUNT`)
- **包名**: 全小写，点分隔 (如 `com.yamato.base.modules.user`)

#### 实体类规范
```java
@Entity
@Table(name = "m_user")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User extends BaseEntity {
    
    @Column(name = "user_id", nullable = false, unique = true, length = 20)
    private String userId;
    
    @Column(name = "user_name", nullable = false, length = 100)
    private String userName;
    
    @Column(name = "email", length = 100)
    private String email;
    
    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;
}
```

#### API响应格式
所有API必须返回统一格式：
```java
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {
    
    private final UserService userService;
    
    @GetMapping("/{userId}")
    public Result<UserDTO> getUser(@PathVariable String userId) {
        return userService.getUserById(userId);
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<UserDTO> createUser(@Valid @RequestBody CreateUserDTO dto) {
        return userService.createUser(dto);
    }
}
```

#### 异常处理
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<Result<Void>> handleBusinessException(BusinessException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Result.error(e.getCode(), e.getMessage()));
    }
    
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Result<Void>> handleAccessDeniedException(AccessDeniedException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(Result.error(403, "没有访问权限"));
    }
}
```

## 数据库规范

### 表命名
- 主表: `m_模块名` (如 `m_user`, `m_screen`)
- 关联表: `r_表1_表2` (如 `r_user_role`)
- 历史表: `h_表名` (如 `h_user`)

### 字段命名
- 使用snake_case (如 `user_id`, `created_at`)
- 主键: `id` (BIGSERIAL)
- 外键: `表名_id` (如 `user_id`)
- 时间戳: `created_at`, `updated_at`
- 软删除: `is_active` (BOOLEAN DEFAULT TRUE)

### 索引规范
```sql
-- 唯一索引
CREATE UNIQUE INDEX uk_user_email ON m_user(email);

-- 普通索引
CREATE INDEX idx_user_role ON m_user(role_id);

-- 复合索引
CREATE INDEX idx_order_status_date ON t_order(status, created_date);
```

## 权限系统

### 权限级别
- `2`: 可编辑 (○)
- `1`: 只读 (△)
- `0`: 不可见 (×)
- `-1`: 无权限检查 (-)

### 权限检查
前端使用`usePermission` Hook:
```typescript
const { canRead, canWrite, accessLevel } = usePermission('b2');
```

后端使用`@PreAuthorize`注解:
```java
@GetMapping("/{id}")
@PreAuthorize("hasPermission(#id, 'READ')")
public Result<OrderDTO> getOrder(@PathVariable String id) {
    // 实现
}
```

## 测试规范

### 前端测试
```typescript
// 组件测试
describe('UserComponent', () => {
  it('应该正确渲染用户信息', () => {
    render(<UserComponent userId="123" userName="测试用户" />);
    expect(screen.getByText('测试用户')).toBeInTheDocument();
  });
});

// Hook测试
describe('usePermission', () => {
  it('应该返回正确的权限级别', () => {
    const { result } = renderHook(() => usePermission('b2'));
    expect(result.current.accessLevel).toBe(2);
  });
});
```

### 后端测试
```java
@SpringBootTest
@AutoConfigureMockMvc
class UserControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    @WithMockUser(username = "admin", roles = {"ADMIN"})
    void testGetUser() throws Exception {
        mockMvc.perform(get("/api/v1/users/123"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200));
    }
}
```

## 提交规范

### Git提交消息
格式: `类型(范围): 描述`

类型:
- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具变动

示例:
```
feat(user): 添加用户注册功能
fix(auth): 修复登录token过期问题
docs(readme): 更新项目文档
```

### 分支策略
- `main`: 主分支，保护分支
- `develop`: 开发分支
- `feature/*`: 功能分支
- `bugfix/*`: 修复分支
- `release/*`: 发布分支

## 部署规范

### 环境变量
```bash
# 前端环境变量
VITE_API_BASE_URL=http://localhost:8080
VITE_APP_ENV=development

# 后端环境变量
SPRING_PROFILES_ACTIVE=dev
DB_HOST=localhost
REDIS_HOST=localhost
JWT_SECRET=your-secret-key
```

### Docker配置
```yaml
# docker-compose.yml
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
  
  backend:
    build: ./backend
    ports:
      - "8080:8080"
  
  postgres:
    image: postgres:15
  
  redis:
    image: redis:7-alpine
```

## 性能优化

### 前端优化
- 使用React.memo()优化组件渲染
- 使用useMemo/useCallback避免不必要的计算
- 代码分割和懒加载
- 图片优化和CDN

### 后端优化
- 数据库查询优化（索引、分页）
- 缓存策略（Redis）
- 连接池配置
- 异步处理耗时操作

## 安全规范

### 前端安全
- 输入验证和清理
- XSS防护
- CSRF Token
- 敏感信息不存储在localStorage

### 后端安全
- SQL注入防护（使用PreparedStatement）
- XSS防护（输入输出编码）
- 文件上传验证
- 密码哈希（BCrypt）
- 接口限流

## 监控和日志

### 日志级别
- ERROR: 系统错误
- WARN: 警告信息
- INFO: 业务日志
- DEBUG: 调试信息

### 日志格式
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "INFO",
  "service": "user-service",
  "traceId": "abc123",
  "message": "用户登录成功",
  "userId": "123",
  "ip": "192.168.1.1"
}
```

## 相关文档
- API接口设计: `./API接口设计/`
- 数据库设计: `./数据库设计/`
- 技术架构规范: `./別紙_画面一覧_v151/_公共技术架构规范.md`
- 各画面设计规范: `./別紙_画面一覧_v151/[画面ID]/05_设计规范.md`

---
*最后更新: 2026-02-05*