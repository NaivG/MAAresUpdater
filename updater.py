import datetime
import os
import sys
import json
import zipfile
import threading
import shutil
from urllib.parse import urljoin
import requests
import psutil
from colorama import Fore, Style, init
from tqdm import tqdm
from ping3 import ping
from prettytable import PrettyTable

# 初始化颜色输出
init(autoreset=True)

# 配置信息
DEPENDENCIES = {
    'MAA.exe': ''
}

MIRROR_SOURCES = {
    'github': 'https://github.com',
    'bgithub': 'https://bgithub.xyz',
    'ghproxy.net': 'https://ghproxy.net/https://github.com',
    'ghfast': 'https://ghfast.top/https://github.com',
    'ghp.ci': 'https://ghp.ci/https://github.com',
    'kgithub': 'https://kkgithub.com',
    'gitproxy.click': 'https://gitproxy.click/https://github.com',
    'moeyy01': 'https://github.moeyy.xyz/https://github.com'
}

MIN_FILE_SIZE = 100000  # 最小文件大小阈值

# 工具函数
def print_color(text, color=Fore.WHITE):
    print(f"{color}{text}{Style.RESET_ALL}")

def input_with_timeout(prompt, timeout):
    print(prompt)
    result = []
    def get_input():
        result.append(sys.stdin.read(1))
    
    thread = threading.Thread(target=get_input)
    thread.daemon = True
    thread.start()
    thread.join(timeout)
    return bool(result)

def check_dependencies():
    missing = []
    for dep, path in DEPENDENCIES.items():
        if not os.path.exists(os.path.join(path, dep)):
            missing.append(dep)
    return missing

def check_process_running(process_name):
    for proc in psutil.process_iter(['name']):
        if proc.info['name'] == process_name:
            return True
    return False

def test_mirror_latency(mirrors):
    results = {}
    table = PrettyTable()
    table.field_names = ['Git Source 镜像源', 'Latency 延迟']
    print("按下Ctrl+C中止测试")
    with tqdm(total=len(mirrors), desc="测试镜像源延迟") as pbar:
        try:
            for name, url in mirrors.items():
                host = url.split('/')[2]
                latency = ping(host, unit='ms')
                if latency is not None and latency != 0.0:
                    results[name] = latency
                if latency is not None and latency != 0.0:
                    if latency < 200:
                        table.add_row([name, Fore.GREEN + f"{latency:.1f}ms" + Style.RESET_ALL])
                    elif latency < 500:
                        table.add_row([name, Fore.YELLOW + f"{latency:.1f}ms" + Style.RESET_ALL])
                    else:
                        table.add_row([name, Fore.RED + f"{latency:.1f}ms" + Style.RESET_ALL])
                else:
                    table.add_row([name, Fore.RED + "超时" + Style.RESET_ALL])
                pbar.update(1)
        except KeyboardInterrupt:
            pbar.close()
            pass
    print(table)
    return sorted(results.items(), key=lambda x: x[1]) if results else None

def download_file(url, filename):
    try:
        response = requests.get(url, stream=True)
        total_size = int(response.headers.get('content-length', 0))
        print_color(f"下载资源: {filename} ({total_size/1024:.1f}KB)", Fore.CYAN)
        if total_size < MIN_FILE_SIZE:
            print_color(f"镜像源错误: 文件大小小于{MIN_FILE_SIZE}字节", Fore.RED)
            return False

        with open(filename, 'wb') as f:
            with tqdm(total=total_size, unit='B', unit_scale=True, desc="下载资源") as pbar:
                for data in response.iter_content(chunk_size=1024):
                    f.write(data)
                    pbar.update(len(data))
        # if not os.path.exists(filename) or os.path.getsize(filename) < MIN_FILE_SIZE:
        #     print_color(f"下载失败: 下载文件大小小于{MIN_FILE_SIZE}字节", Fore.RED)
        #     os.remove(filename) if os.path.exists(filename) else None
        #     return False
        return True
    except Exception as e:
        print_color(f"下载失败: {str(e)}", Fore.RED)
        return False

def main():
    # 检查主程序
    # if not os.path.exists("MAA.exe"):
    maa_program = ""
    for filename in ["MAA.exe", "maa", "maa.sh", "MAA.bin"]:
        if os.path.exists(filename):
            maa_program = filename
    if not maa_program or not os.path.isfile(maa_program):
        print_color("[ERROR] 未找到MaaAssistant主程序", Fore.RED)
        return

    # 检查依赖
    # missing = check_dependencies()
    # if missing:
    #     print_color(f"[ERROR] 缺失依赖文件: {', '.join(missing)}", Fore.RED)
    #     return

    # 检查进程
    if check_process_running(maa_program):
        print_color("[ERROR] 检测到MaaAssistant正在运行", Fore.RED)
        return

    # 显示条款
    print_color("[INFO] 欢迎使用MaaAssistant资源更新工具！", Fore.GREEN)
    print("1. 此脚本是为了应付MAA暂时取消自动更新的情况")
    print("2. 请不要开启旧版控制台")
    print("3. 发现有问题请发issues")
    print("4. 婴儿请出门右拐宝宝巴士\n")
    input("按回车键确认条款并继续...")

    # 测试镜像源
    print_color("[INFO] 测试镜像源延迟...", Fore.GREEN)
    latency_results = test_mirror_latency(MIRROR_SOURCES)
    
    if not latency_results:
        print_color("[ERROR] 无法连接任何镜像源", Fore.RED)
        return

    selected_mirror = latency_results[0]

    print_color(f"[INFO] 自动选择镜像源: {selected_mirror[0]} ({selected_mirror[1]:.1f}ms)", Fore.GREEN)
    if input_with_timeout("如果要手动切换镜像源，请在5秒内按下任意键...", 5):
        print_color("请选择镜像源:", Fore.CYAN)
        for i, (name, latency) in enumerate(latency_results, 1):
            print(f"{i}. {name} ({latency:.1f}ms)")
            
        # 获取用户选择
        while True:
            try:
                choice = int(input("请输入数字选择: "))
                if 1 <= choice <= len(latency_results):
                    selected_mirror = latency_results[choice-1]
                    break
                print_color("输入无效，请重新输入", Fore.RED)
            except ValueError:
                print_color("请输入数字", Fore.RED)
                break

    # 下载资源
    download_url = urljoin(MIRROR_SOURCES[selected_mirror[0]], 
                        "/MaaAssistantArknights/MaaResource/archive/refs/heads/main.zip")
    
    if os.path.exists("maares.zip"):
        if os.path.exists("maares.zip.aria2"):
            os.remove("maares.zip.aria2")
        os.remove("maares.zip")

    if not download_file(download_url, "maares.zip"):
        # 下载失败，回退到备用镜像源
        print_color("[INFO] 下载失败，尝试备用镜像源...", Fore.YELLOW)
        latency_results.remove(selected_mirror)
        for idx, (name, latency) in enumerate(latency_results, 1):
            print(f"回退到 {name} 镜像源[{idx}/{len(latency_results)}]")
            download_url = urljoin(MIRROR_SOURCES[name], "/MaaAssistantArknights/MaaResource/archive/refs/heads/main.zip")
            if download_file(download_url, "maares.zip"):
                break

    if not os.path.exists("maares.zip"):
        print_color("[ERROR] 下载失败，请检查网络连接或镜像源", Fore.RED)
        return

    if os.path.exists("MaaResource-main"):
        shutil.rmtree("MaaResource-main")

    # 解压文件
    print_color("[INFO] 校验并解压文件...", Fore.GREEN)
    with zipfile.ZipFile("maares.zip", 'r') as zip_ref:
        try:
            zip_ref.testzip()  # 校验文件完整性
            print_color("[INFO] 文件完整性校验通过", Fore.GREEN)
            zip_ref.extractall() # 解压到当前目录
        except zipfile.BadZipFile:
            print_color("[ERROR] 文件校验失败，请重新下载", Fore.RED)
            return
        except Exception as e:
            print_color(f"[ERROR] 解压失败: {str(e)}", Fore.RED)
            return

    try:
        print_color("[INFO] 解压完成，准备更新资源...", Fore.GREEN)

        with open("MaaResource-main/resource/version.json", "r", encoding="utf-8") as f:
            version = json.load(f)

        if 'activity' in version:
            print_color(f"当前版本: {version['activity']['name']}", Fore.GREEN)
        print_color(f"资源更新时间: {version['last_updated']}", Fore.GREEN)
        update_time = datetime.datetime.strptime(version['last_updated'], "%Y-%m-%d %H:%M:%S.%f")

        if os.path.exists("resource/version.json"):
            with open("resource/version.json", "r", encoding="utf-8") as f:
                old_version = json.load(f)

            old_update_time = datetime.datetime.strptime(old_version['last_updated'], "%Y-%m-%d %H:%M:%S.%f")

            if old_update_time >= update_time:
                print_color("[WARNING] 检测到拉取的资源版本旧于本地的版本: " + old_version['last_updated'], Fore.YELLOW)
                if not input_with_timeout("如果要继续更新，请在5秒内按下任意键...", timeout=5):
                    return
                
    except Exception as e:
        print_color(f"[ERROR] 获取版本信息失败: {e}", Fore.RED)
        if not input_with_timeout("如果要继续更新，请在5秒内按下任意键...", timeout=5):
            return
    try:
        with tqdm(total=3, desc="更新资源") as pbar:
            shutil.copytree("MaaResource-main/cache", "cache", dirs_exist_ok=True)
            pbar.update(1)
            shutil.copytree("MaaResource-main/resource", "resource", dirs_exist_ok=True)
            pbar.update(1)
            shutil.rmtree("MaaResource-main")
            pbar.update(1)
        os.remove("maares.zip")
        print_color("[INFO] 更新完成，请重启MaaAssistant", Fore.GREEN)
    except Exception as e:
        print_color(f"[ERROR] 文件操作失败: {str(e)}", Fore.RED)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print_color("\n操作已取消", Fore.YELLOW)
    finally:
        input("按回车键退出...")
        os._exit(0)