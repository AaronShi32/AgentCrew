# AgentCrew

基于 CrewAI 的多团队 AI Agent 项目。一个 repo 管理多个独立的 Agent 团队，部署到 Crew Studio 后可分别运行。

## 快速开始

```bash
# 安装依赖
pip install -e .

# 配置环境变量
cp .env.example .env
# 编辑 .env 填入你的 API Key

# 本地运行
crewai run
```

## 项目结构

```
src/agent_crew/
├── main.py                        # Flow 入口
├── crews/
│   └── example_crew/              # 示例团队
│       ├── example_crew.py        # CrewBase 类
│       └── config/
│           ├── agents.yaml        # Agent 定义
│           └── tasks.yaml         # Task 定义
└── tools/                         # 共享自定义工具
```

## 如何创建新团队

### 1. 创建目录

```bash
mkdir -p src/agent_crew/crews/my_team/config
touch src/agent_crew/crews/my_team/__init__.py
```

### 2. 定义 Agents (`config/agents.yaml`)

```yaml
analyst:
  role: "Data Analyst"
  goal: "Analyze data and extract insights"
  backstory: >
    You are a senior data analyst with expertise in
    finding patterns and generating actionable insights.
```

### 3. 定义 Tasks (`config/tasks.yaml`)

```yaml
analysis_task:
  description: >
    Analyze the following data: {data}
    Identify key trends and anomalies.
  expected_output: "A structured analysis report"
  agent: analyst
```

### 4. 创建 Crew 类 (`my_team.py`)

```python
from crewai import Agent, Crew, Process, Task
from crewai.project import CrewBase, agent, crew, task


@CrewBase
class MyTeam:
    """My custom team."""

    agents_config = "config/agents.yaml"
    tasks_config = "config/tasks.yaml"

    @agent
    def analyst(self) -> Agent:
        return Agent(config=self.agents_config["analyst"], verbose=True)

    @task
    def analysis_task(self) -> Task:
        return Task(config=self.tasks_config["analysis_task"])

    @crew
    def crew(self) -> Crew:
        return Crew(
            agents=self.agents,
            tasks=self.tasks,
            process=Process.sequential,
            verbose=True,
        )
```

### 5. 注册到 Flow (`main.py`)

在 `AgentCrewFlow` 中添加一个方法：

```python
from agent_crew.crews.my_team.my_team import MyTeam

@start()
def run_my_team(self):
    return MyTeam().crew().kickoff(inputs={"data": "..."})
```

## 部署到 Crew Studio

```bash
# 首次登录
crewai login

# 一键部署
./deploy.sh

# 或分步操作
./deploy.sh create   # 创建部署配置
./deploy.sh push     # 发布到 Crew Studio
./deploy.sh status   # 查看状态
./deploy.sh logs     # 查看日志
./deploy.sh list     # 列出所有部署
./deploy.sh remove   # 删除部署
```
