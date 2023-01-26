@ECHO ON

del /f frontend.tf
del /f frontend-variables.tf
del /f pfm-api.tf
del /f pfm-api-variables.tf

MKLINK frontend.tf ..\common\frontend.tf
MKLINK frontend-variables.tf ..\common\frontend-variables.tf
MKLINK pfm-api.tf ..\common\pfm-api.tf
MKLINK pfm-api-variables.tf ..\common\pfm-api-variables.tf

PAUSE
EXIT