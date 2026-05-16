#!/usr/bin/env bash
# deploy.sh — 一键部署到 CrewAI Enterprise (AMP)
# 用法: ./deploy.sh [create|push|status|logs|list|remove]
#   无参数默认执行 create + push 完整流程

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# ---------- 前置检查 ----------
check_prerequisites() {
    command -v crewai >/dev/null 2>&1 || error "crewai CLI 未安装。请先运行: pip install 'crewai[tools]'"

    if [ ! -f pyproject.toml ]; then
        error "请在项目根目录下运行此脚本"
    fi

    if [ ! -f .env ]; then
        warn ".env 文件不存在。正在从 .env.example 创建..."
        if [ -f .env.example ]; then
            cp .env.example .env
            warn "请编辑 .env 填入你的 API Key，然后重新运行"
            exit 1
        else
            error "未找到 .env.example，请手动创建 .env"
        fi
    fi
}

# ---------- 子命令 ----------
do_create() {
    info "在 Crew Studio 创建部署配置..."
    crewai deploy create
    info "部署配置创建完成"
}

do_push() {
    info "发布到 Crew Studio..."
    crewai deploy push
    info "发布完成"
}

do_status() {
    info "查询部署状态..."
    crewai deploy status
}

do_logs() {
    info "流式输出部署日志..."
    crewai deploy logs
}

do_list() {
    info "列出所有部署..."
    crewai deploy list
}

do_remove() {
    info "移除部署..."
    crewai deploy remove
}

do_full_deploy() {
    info "========== 开始部署到 Crew Studio =========="
    do_create
    echo ""
    do_push
    echo ""
    info "已发布，正在查询状态..."
    do_status
    echo ""
    info "========== 部署完成 =========="
    info "运行 ./deploy.sh logs 查看部署日志"
    info "运行 ./deploy.sh status 查看部署状态"
}

# ---------- 主入口 ----------
check_prerequisites

case "${1:-}" in
    create) do_create ;;
    push)   do_push ;;
    status) do_status ;;
    logs)   do_logs ;;
    list)   do_list ;;
    remove) do_remove ;;
    "")     do_full_deploy ;;
    *)      error "未知命令: $1\n用法: $0 [create|push|status|logs|list|remove]" ;;
esac
