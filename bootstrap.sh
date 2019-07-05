#!/bin/bash
#
# *******************************************************************************
#  * Copyright (c) 2019 Edgeworx, Inc.
#  *
#  * This program and the accompanying materials are made available under the
#  * terms of the Eclipse Public License v. 2.0 which is available at
#  * http://www.eclipse.org/legal/epl-2.0
#  *
#  * SPDX-License-Identifier: EPL-2.0
#  *******************************************************************************
#

. ./scripts/utils.sh

OS=$(uname -s | tr A-Z a-z)
GCLOUD_VERSION=253.0.0
GCP_SDK_PACKAGE_URL="https://console.cloud.google.com/storage/browser/cloud-sdk-release?authuser=0&prefix=google-cloud-sdk-${GCLOUD_VERSION}"
GCP_SDK_INSTRUCTION_URL="https://cloud.google.com/sdk/docs/downloads-versioned-archives"
LIB_LOCATION=/usr/local/lib

TERRAFORM_VERSION=0.11.14
TERRAFORM_PACKAGE_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/"
TERRAFORM_INSTRUCTION_URL="https://cloud.google.com/sdk/docs/downloads-versioned-archives"

KUBECTL_INSTRUCTION_URL="https://kubernetes.io/docs/tasks/tools/install-kubectl/"

ANSIBLE_INSTRUCTION_URL="https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#intro-installation-guide"

help_install_gcp_sdk() {
    echoError "We could not automatically install gcloud sdk"
    echoInfo "Please follow the installation instructions from here: ${GCP_SDK_INSTRUCTION_URL}"
}

install_gcp() {
    if [[ "$1" == "windows" ]]; then
        help_install_gcp_sdk
        return 1
    fi
    curl -Lo gcloud.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-"$GCLOUD_VERSION"-"$1"-x86_64.tar.gz
    sudo mkdir -p "$LIB_LOCATION"/
    tar -xf gcloud.tar.gz -C "$LIB_LOCATION"
    rm gcloud.tar.gz
    "$LIB_LOCATION"/google-cloud-sdk/install.sh -q
    source "$LIB_LOCATION"/google-cloud-sdk/completion.bash.inc
    source "$LIB_LOCATION"/google-cloud-sdk/path.bash.inc
    if [[ -z $(command -v gcloud) ]]; then
        help_install_gcp_sdk
        return 1
    else
        echoSuccess "gcloud installed"
        gcloud --version
        echo ""
        return 0
    fi
}

check_gcp() {
    { # Try
        if [[ -z $(command -v gcloud) ]]; then
            echoInfo "====> Installing gcloud sdk..."
            if [[ "$OSTYPE" == "linux-gnu" ]]; then
                install_gcp "linux"
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                # Mac OSX
                install_gcp "darwin"
            elif [[ "$OSTYPE" == "cygwin" ]]; then
                # POSIX compatibility layer and Linux environment emulation for Windows
                install_gcp "windows"
            elif [[ "$OSTYPE" == "msys" ]]; then
                # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
                install_gcp "windows"
            elif [[ "$OSTYPE" == "win32" ]]; then
                # I'm not sure this can happen.
                install_gcp "windows"
            elif [[ "$OSTYPE" == "freebsd"* ]]; then
                install_gcp "linux"
            else
                help_install_gcp_sdk
                return 1
            fi
        else
            echoSuccess "gcloud found in path!"
            gcloud --version    
            echo ""
            return 0
        fi
        return $?
    } || { # Catch
        help_install_gcp_sdk
        return 1
    }
}

help_install_tf() {
    echoError "We could not automatically install terraform"
    echoInfo "Please download the relevant zip package according to your operating system from here: ${TERRAFORM_PACKAGE_URL}"
    echoInfo "Terraform is distributed as a single binary. Install Terraform by unzipping it and moving it to a directory included in your system's PATH ."
}

install_tf() {
    echoInfo "====> Installing terraform..."
    if [[ "$1" == "windows" ]]; then
        help_install_tf
        return 1
    fi
    if [[ -z "$(command -v unzip)" ]]; then
        {
            sudo apt-get update -qy && sudo apt-get install -qy unzip > /dev/null
        } || {
            sudo apt update -qy && sudo apt install -qy unzip > /dev/null
        } || {
            sudo yum update -qy && sudo yum install -qy unzip > /dev/null
        } || {
            brew tap homebrew/dupes && brew install unzip > /dev/null
        } || {
            echoError "Could not install unzip"
            help_install_tf
            return 1
        }
        
    fi
    curl -fSL -o terraform.zip https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION"/terraform_"$TERRAFORM_VERSION"_"$1"_amd64.zip
    sudo mkdir -p "$LIB_LOCATION"/
    sudo unzip -q terraform.zip -d "$LIB_LOCATION"/terraform
    rm -f terraform.zip
    sudo ln -Ffs "$LIB_LOCATION"/terraform/terraform /usr/local/bin/terraform
    if [[ -z $(command -v terraform) ]]; then
        help_install_tf
        return 1
    else
        echoSuccess "terraform installed"
        terraform --version
        echo ""
        return 0
    fi
}

check_tf() {
    { # Try
        if [[ -z $(command -v terraform) ]]; then
            if [[ "$OSTYPE" == "linux-gnu" ]]; then
                install_tf "linux"
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                # Mac OSX
                install_tf "darwin"
            elif [[ "$OSTYPE" == "cygwin" ]]; then
                # POSIX compatibility layer and Linux environment emulation for Windows
                install_tf "windows"
            elif [[ "$OSTYPE" == "msys" ]]; then
                # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
                install_tf "windows"
            elif [[ "$OSTYPE" == "win32" ]]; then
                # I'm not sure this can happen.
                install_tf "windows"
            elif [[ "$OSTYPE" == "freebsd"* ]]; then
                install_tf "freebsd"
            else
                help_install_tf
                return 1
            fi
        else
            echoSuccess "terraform found in path!"
            terraform --version    
            echo ""
            return 0            
        fi
        return $?
    } || { # Catch
        help_install_tf
        return 1
    }
}

#
# Check between apt or yum
#
install_iofogctl_linux() {
    if [[ -x "$(command -v apt-get)" ]]; then
        curl -s https://packagecloud.io/install/repositories/iofog/iofogctl/script.deb.sh | sudo bash
        sudo apt-get install iofogctl -y
    elif [[ -x "$(command -v apt)" ]]; then
        curl -s https://packagecloud.io/install/repositories/iofog/iofogctl/script.deb.sh | sudo bash
        sudo apt install iofogctl -y
    elif [[ -x "$(command -v yum)" ]]; then
        curl -s https://packagecloud.io/install/repositories/iofog/iofogctl/script.rpm.sh | sudo bash
        sudo yum install iofogctl -y
    else
        iofogctl_install_exit
        return 1
    fi
    iofogctl_install_success
    return $?
}

install_iofogctl_win() {
    echoError "We do not currently support Windows for iofgoctl"
    return 1
}

install_iofogctl_darwin() {
    if [[ -z "$(command -v brew)" ]]; then
        echoInfo "Brew not found"
        iofogctl_install_exit
        return 1
    else
        brew tap eclipse-iofog/iofogctl
        brew install iofogctl
        iofogctl_install_success
        return $?
    fi
}


iofogctl_install_success() {
    if [[ -z "$(command -v iofogctl)" ]]; then
        iofogctl_install_exit
        return 1
    else
        echoSuccess "iofogctl installed!"
        iofogctl version
        echo ""
        return 0
    fi
}

iofogctl_install_exit() {
    echoInfo "Could not detect package installation system"
    echoInfo "Please follow github instructions to install iofogctl: https://github.com/eclipse-iofog/iofogctl"
}

#
# Install iofogctl
#
install_iofogctl() {
    echoInfo "====> Installing iofogctl..."
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        install_iofogctl_linux
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        install_iofogctl_darwin
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        install_iofogctl_win
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        install_iofogctl_win
    elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
        install_iofogctl_win
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        install_iofogctl_linux
    else
        iofogctl_install_exit
        return 1
    fi
    return $?
}

#
# Check if iofogctl exists
#
check_iofogctl() {
    {
        if [[ -z "$(command -v iofogctl)" ]]; then
            install_iofogctl
            return $?
        else
            echoSuccess "iofogctl found in path!"
            iofogctl version    
            echo ""
            return 0
        fi
    } || {
        iofogctl_install_exit
        return 1
    }
}

help_install_kubectl() {
    echoError "We could not automatically install kubectl"
    echoInfo "Please follow the installation instructions from here: ${KUBECTL_INSTRUCTION_URL}"
}

install_kubectl_success() {
    if [[ -z "$(command -v kubectl)" ]]; then
        help_install_kubectl
        return 1
    else
        echoSuccess "kubectl installed!"
        kubectl version
        echo ""
        return 0
    fi
}

install_kubectl() {
    echoInfo "====> Installing kubectl..."
    if [[ "$1" == "windows" ]]; then
        help_install_kubectl
        false
        return
    fi
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/$1/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    install_kubectl_success
    return $?
}

check_kubectl() {
    {
        if ! [[ -x "$(command -v kubectl)" ]]; then
            if [[ "$OSTYPE" == "linux-gnu" ]]; then
                install_kubectl "linux"
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                # Mac OSX
                install_kubectl "darwin"
            elif [[ "$OSTYPE" == "cygwin" ]]; then
                # POSIX compatibility layer and Linux environment emulation for Windows
                install_kubectl "windows"
            elif [[ "$OSTYPE" == "msys" ]]; then
                # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
                install_kubectl "windows"
            elif [[ "$OSTYPE" == "win32" ]]; then
                # I'm not sure this can happen.
                install_kubectl "windows"
            elif [[ "$OSTYPE" == "freebsd"* ]]; then
                install_kubectl "linux"
            else
                help_install_kubectl
                false
            fi
        else
            echoSuccess "kubectl found in path!"
            kubectl version    
            echo ""
            return 0
        fi
        return $?
    } || {
        help_install_kubectl
        return 1
    }
    
}

help_install_ansible() {
    echoError "We could not automatically install ansible"
    echoInfo "Please follow the installation instructions from here: ${ANSIBLE_INSTRUCTION_URL}"
}

install_ansible_success() {
    if [[ -z "$(command -v ansible)" ]]; then
        help_install_ansible
        return 1
    else
        echoSuccess "ansible installed!"
        ansible --version
        echo "" 
        return 0
    fi
}

install_ansible() {
    echoInfo "====> Installing ansible..."
    if [[ "$1" == "windows" ]]; then
        help_install_ansible
        return 1
    fi
    if [[ -z "$(command -v pip3)" ]] && [[ -z "$(command -v pip)" ]]; then
    {
        (python3 <(wget -O- https://bootstrap.pypa.io/get-pip.py 2>/dev/null)) > /dev/null
    } || {
        (python <(wget -O- https://bootstrap.pypa.io/get-pip.py 2>/dev/null)) > /dev/null
    }
    fi
    {
        pip install --prefix /usr/local ansible
    } || {
        pip3 install --prefix /usr/local ansible
    }
    if [[ -z "$(command -v ansible)" ]]; then
        help_install_ansible
        return 1
    else
        echoSuccess "ansible installed!"
        ansible --version
        echo "" 
        return 0
    fi
}

check_ansible() {
    {
        if ! [[ -x "$(command -v ansible)" ]]; then
            if [[ "$OSTYPE" == "linux-gnu" ]]; then
                install_ansible "linux"
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                # Mac OSX
                install_ansible "darwin"
            elif [[ "$OSTYPE" == "cygwin" ]]; then
                # POSIX compatibility layer and Linux environment emulation for Windows
                install_ansible "windows"
            elif [[ "$OSTYPE" == "msys" ]]; then
                # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
                install_ansible "windows"
            elif [[ "$OSTYPE" == "win32" ]]; then
                # I'm not sure this can happen.
                install_ansible "windows"
            elif [[ "$OSTYPE" == "freebsd"* ]]; then
                install_ansible "linux"
            else
                help_install_ansible
                return 1
            fi
            return $?
        else
            echoSuccess "ansible found in path!"
            ansible --version    
            echo ""
            return 0
        fi
    } || {
        help_install_ansible
        return 1
    }
}

display_gcp_final_instructions() {
    prettyTitle "Next Steps"
    echo "Please run the following commands and add them in your shell profile file:"
    echo "source $LIB_LOCATION/google-cloud-sdk/completion.bash.inc"
    echo "source $LIB_LOCATION/google-cloud-sdk/path.bash.inc"
    echo ""
}

prettyHeader "Bootstrapping ioFog platform dependencies"

if ! [[ -x "$(command -v curl)" ]]; then
    echoError "curl not found"
    exit 1
fi


if [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echoError "We do not currently support windows"
    exit 1
fi

check_gcp
gcp_success=$?
check_tf
tf_success=$?
check_ansible
ansible_success=$?
check_kubectl
kubectl_success=$?
check_iofogctl
iofogctl_success=$?

echoInfo "Setting up Terraform files..."
cp ./infrastructure/environments_gke/user/vars.template.tfvars ./my_vars.tfvars
cp ./scripts/credentials.template.sh ./my_credentials.sh

success=0
echo ""
prettyTitle "Bootstrap Summary:"
if [[ $tf_success -ne 0 ]]; then
    echoError " ✖️ Terraform" 
    help_install_tf
    success=1
else
    echoSuccess " ✔️  Terraform"
fi
if [[ $ansible_success -ne 0 ]]; then
    echoError " ✖️ Ansible" 
    help_install_ansible
    success=1
else
    echoSuccess " ✔️  Ansible"
fi
if [[ $kubectl_success -ne 0  ]]; then
    echoError " ✖️ Kubectl" 
    help_install_kubectl
    success=1
else
    echoSuccess " ✔️  Kubectl"
fi
if [[ $iofogctl_success -ne 0  ]]; then
    echoError " ✖️ Iofogctl" 
    iofogctl_install_exit
    success=1
else
    echoSuccess " ✔️  Iofogctl"
fi
if [[ $gcp_success -ne 0  ]]; then
    echoError " ✖️ Gcloud" 
    help_install_gcp_sdk
    success=1
else
    echoSuccess " ✔️  Gcloud"
    display_gcp_final_instructions
fi
exit $success