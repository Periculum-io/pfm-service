@ECHO ON

del /f frontend.tf
del /f frontend-variables.tf
del /f pfm-admin-api.tf
del /f pfm-admin-api-variables.tf

MKLINK frontend.tf ..\common\frontend.tf
MKLINK frontend-variables.tf ..\common\frontend-variables.tf
MKLINK pfm-admin-api.tf ..\common\pfm-admin-api.tf
MKLINK pfm-admin-api-variables.tf ..\common\pfm-admin-api-variables.tf

PAUSE
EXIT