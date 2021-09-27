export LANG=en_US.UTF-8
vmos=""

getvmList() {
    local ifsbak=$IFS
    local suffix=$1
    local count=0
    local vm=""
    IFS=$'\n'
    for vm in $(ls); do
        if [[ ${vm##*.} == "$suffix" ]]; then
            vmos[((count++))]=${vm%.*}
            echo "$count. $vm"
        fi
    done
    IFS=$ifsbak
    return $count
}

selectvmOs() {
    getvmList pvm
    local cnt=$?
    local n=0
    if [ $[cnt] -gt 0 ]; then
        read -t 10 -p "请输入序号[1-"$cnt"]: " n
    else
        echo "<将此脚本与虚拟系统文件放在一起后,再运行!>"
        exit 1
    fi
    if [[ $[n] -lt 1 || $[n] -gt $cnt ]]; then
        echo "<序号不存在!>"
        exit 1
    fi
    prlctl start "${vmos[n-1]}"
    open /Applications/Parallels\ Desktop.app
}

#######################################################
cd $(dirname $BASH_SOURCE) || {
    echo "<获取脚本目录出错!>"
    exit 1
}
selectvmOs




