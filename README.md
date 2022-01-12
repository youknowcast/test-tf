# test-tf

my terraform project for study.

## tools

* tfenv

uninstall terraform if you installed with `brew install terraform`

```
% brew install tfenv
% tfenv install 1.1.3
%tfenv use 1.1.3
```

* tfsec

it lists insecure code

```
% brew install tfsec

# use
% tfsec
```

* git-secrets

```
% brew install git-secrets

# setting
% git secrets --register-aws --global
% git secrets --install ~/.git-templates/git-secrets
% git config --global init.templatedir '~/.git-templates/git-secrets'
```

## 参考にしたもの

* SoftwareDesign 2022-01
* 実践 Terraform AWS 設計におけるシステム設計とベストプラクティス