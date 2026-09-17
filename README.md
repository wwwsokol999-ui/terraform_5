# Terraform 05 — Использование Terraform в команде

Домашнее задание по работе с Terraform в командной среде.

## Задание 1. Проверка конфигурации TFLint и Checkov

Код был проверен с помощью `tflint` и `checkov`.

### TFLint

Обнаружены следующие уникальные типы предупреждений:

1. `terraform_module_pinned_source` — внешний модуль был подключён через `ref=main`, то есть использовалась плавающая ветка вместо конкретного commit/tag.
2. `terraform_required_providers` — для провайдеров `yandex` и `template` отсутствовали ограничения по версии.
3. `terraform_unused_declarations` — в конфигурации были объявлены, но не использовались переменные.

### Checkov

Обнаружены следующие уникальные типы ошибок:

1. `CKV_TF_1` — источник Terraform-модуля не был закреплён на конкретный commit hash.
2. `CKV_TF_2` — источник Terraform-модуля не был закреплён на version tag.

## Задание 2. Remote state и блокировка

Для хранения Terraform state настроен S3 backend в Yandex Object Storage.

Используется:

- bucket: `terraform-state-wwwsokol999-05`;
- key: `terraform.tfstate`;
- region: `ru-central1`;
- `use_lockfile = true`;
- endpoint: `https://storage.yandexcloud.net`.

Локальный state был перенесён в удалённый backend командой:

```bash
terraform init -migrate-state
```

После миграции remote state успешно читает управляемые ресурсы через:

```bash
terraform state list
```

Блокировка state была проверена параллельным запуском `terraform console` и `terraform apply`.

Terraform корректно вернул ошибку:

```text
Error: Error acquiring the state lock
```

После этого блокировка была снята командой:

```bash
terraform force-unlock <LOCK_ID>
```

## Задание 3. Hotfix, TFLint и Checkov

Исправления выполнялись в ветке `terraform-hotfix`, созданной от `terraform-05`.

Выполнено:

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
```

Pull Request должен быть направлен из `terraform-hotfix` в `terraform-05` и оставлен без merge.

## Задание 4. Validation для IP-адресов

Добавлена validation для одиночного IPv4-адреса:

```hcl
variable "ip_address" {
  type        = string
  description = "IP-адрес"
  default     = "192.168.0.1"

  validation {
    condition     = can(cidrhost("${var.ip_address}/32", 0))
    error_message = "Значение должно быть корректным IPv4-адресом."
  }
}
```

Добавлена validation для списка IPv4-адресов:

```hcl
variable "ip_addresses" {
  type        = list(string)
  description = "Список IP-адресов"

  default = [
    "192.168.0.1",
    "1.1.1.1",
    "127.0.0.1"
  ]

  validation {
    condition = alltrue([
      for ip in var.ip_addresses :
      can(cidrhost("${ip}/32", 0))
    ])

    error_message = "Все значения должны быть корректными IPv4-адресами."
  }
}
```

Проверены как корректные, так и некорректные значения через `terraform console`.

## Итоговая проверка

Конфигурация успешно проходит:

```bash
terraform validate
tflint
checkov -d .
terraform plan
```

Результат:

```text
terraform validate: Success
TFLint: без предупреждений
Checkov: Passed checks: 4, Failed checks: 0
Terraform plan: No changes
```
