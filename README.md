## Задание 1

Код из `04/src` и `04/demonstration1` был проверен с помощью `tflint` и `checkov`.

### TFLint

Обнаружены следующие уникальные типы предупреждений:

1. `terraform_module_pinned_source`  
   Модули подключаются через `ref=main`, то есть используется плавающая ветка вместо конкретного commit/tag.

2. `terraform_required_providers`  
   Для провайдеров `yandex` и `template` не указаны ограничения по версии.

3. `terraform_unused_declarations`  
   В конфигурации присутствуют объявленные, но неиспользуемые переменные.

### Checkov

Обнаружены следующие уникальные типы ошибок:

1. `CKV_TF_1`  
   Источник Terraform-модуля не закреплён на конкретный commit hash.

2. `CKV_TF_2`  
   Источник Terraform-модуля не закреплён на version tag.

В `04/demonstration1` были обнаружены те же типы ошибок, поэтому дубли не перечислялись.

## Задание 3

Исправлены замечания TFLint и Checkov.

### Выполнено

- внешний Terraform-модуль зафиксирован на конкретный commit;
- добавлены version constraints для провайдеров `yandex` и `template`;
- удалены неиспользуемые переменные;
- `terraform validate` выполняется успешно;
- TFLint не обнаруживает ошибок и предупреждений;
- Checkov: `Passed checks: 4, Failed checks: 0`;
- Terraform plan не обнаруживает изменений инфраструктуры.

### Terraform plan

```text
No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration
and found no differences, so no changes are needed.
