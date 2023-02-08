@ECHO ON

del /f frontend.tf
del /f frontend-variables.tf
del /f pfm-admin-api.tf
del /f pfm-admin-api-variables.tf
del /f variables-generic.tf
del /f secrets-manager.tf
del /f secrets-manager-variables.tf
del /f pfm-flask-api.tf
del /f pfm-flask-api-variables.tf
del /f routing.tf
del /f routing-variables.tf
del /f infrastructure.tf
del /f infrastructure-variables.tf

MKLINK frontend.tf ..\common\frontend.tf
MKLINK frontend-variables.tf ..\common\frontend-variables.tf
MKLINK pfm-admin-api.tf ..\common\pfm-admin-api.tf
MKLINK pfm-admin-api-variables.tf ..\common\pfm-admin-api-variables.tf
MKLINK variables-generic.tf ..\common\variables-generic.tf
MKLINK secrets-manager.tf ..\common\secrets-manager.tf
MKLINK secrets-manager-variables.tf ..\common\secrets-manager-variables.tf
MKLINK pfm-flask-api.tf ..\common\pfm-flask-api.tf
MKLINK pfm-flask-api-variables.tf ..\common\pfm-flask-api-variables.tf
MKLINK routing.tf ..\common\routing.tf
MKLINK routing-variables.tf ..\common\routing-variables.tf
MKLINK infrastructure.tf ..\common\infrastructure.tf
MKLINK infrastructure-variables.tf ..\common\infrastructure-variables.tf

PAUSE
EXIT
