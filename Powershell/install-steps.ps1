#Installing in HYPER-V
# https://rudycorradetti.com/2022/08/08/setting-up-kubernetes-in-hyper-v-manual-method/

#vswtich
New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal

#ip-range
New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NATSwitch)"

#NAT-creation
New-NetNat -Name "NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.0.0/24



#create centos7 nodes
#https://wiki.lyrasis.org/display/VIVO/Install+CentOS+7+in+Hyper-V+on+Windows+10

#installed ubuntu
# as this doesnt seem to work on centos
#test server works - no network as in NAT :/ 








#REF - https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/


#Download
curl.exe -LO "https://dl.k8s.io/release/v1.31.0/bin/windows/amd64/kubectl.exe"

#checksum

curl.exe -LO "https://dl.k8s.io/v1.31.0/bin/windows/amd64/kubectl.exe.sha256"


#validate cert
CertUtil -hashfile kubectl.exe SHA256
type kubectl.exe.sha256
##OUTPUT##
#a618de26c86421a394de7041f9d0a87752dd4e555894d2278421cf12097fa531
#CertUtil: -hashfile command completed successfully.
#a618de26c86421a394de7041f9d0a87752dd4e555894d2278421cf12097fa531

#automated check
$(Get-FileHash -Algorithm SHA256 .\kubectl.exe).Hash -eq $(Get-Content .\kubectl.exe.sha256)
##OUTPUT##
#true

#agent version
kubectl version --client
#Output
#Client Version: v1.28.2
#Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3

#agent version detailed
kubectl version --client --output=yaml
#OUTPUT
#clientVersion:
#  buildDate: "2023-09-13T09:35:49Z"
#  compiler: gc
#  gitCommit: 89a4ea3e1e4ddd7f7572286090359983e0387b2f
#  gitTreeState: clean
#  gitVersion: v1.28.2
#  goVersion: go1.20.8
#  major: "1"
#  minor: "28"
#  platform: windows/amd64
#kustomizeVersion: v5.0.4-0.20230601165947-6ce0bf390ce3


# install k8s 
winget install -e --id Kubernetes.kubectl


#
kubectl version --client
#Client Version: v1.28.2
#Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3



cd %USERPROFILE%

pwd
mkdir .kube
cd .kube

#didnt work
New-Item config -type file


# config info
kubectl cluster-info


#info dump
kubectl cluster-info dump

#
kubectl completion powershell | Out-String | Invoke-Expression

#
kubectl completion powershell >> $PROFILE




#--------
#guide - https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download

# minikube installer
New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing

#adding path
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains 'C:\minikube'){
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine)
}


#
minikube start


#
minikube start --kubernetes-version=v1.30.0



#--------------
# docker start
Start-Service com.docker* -Passthru

#-----------
#windows features
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V, Containers -All

Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\com.docker.windows DisplayName "Docker Engine for Windows"
Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\com.docker.windows Description "Windows Containers Server for Docker"

Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\com.docker.service DisplayName "Docker Engine for Linux"
Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\com.docker.service Description "Linux Containers Server For Docker"

