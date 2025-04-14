# Terraform Destroy Command

The `terraform destroy` command is used to **permanently destroy all resources** managed by a Terraform configuration. It is essentially the reverse of the `terraform apply` command and is useful when you want to completely clean up resources from your infrastructure.

## Usage

```bash
terraform destroy
```

By default, Terraform will prompt for confirmation before destroying resources. To skip the confirmation prompt, use the `-auto-approve` flag:

```bash
terraform destroy -auto-approve
```

## How It Works

When `terraform destroy` is executed, Terraform:
- Reads the state file to identify all resources under management.
- Generates a destroy plan which lists all resources to be deleted.
- Prompts the user for confirmation (unless `-auto-approve` is used).
- Deletes all the resources as specified in the destroy plan.

## Important Flags

- `-auto-approve`: Skips the interactive approval of the destroy plan.
- `-target`: Destroys only the specified resource(s) instead of all resources.
  ```bash
  terraform destroy -target=aws_instance.example
  ```
- `-var`: Allows you to pass variables directly via the command line.
  ```bash
  terraform destroy -var="region=us-west-2"
  ```

## Precautions
- Use `terraform destroy` with caution as it **permanently deletes resources**. Always review the plan before approving.
- Ensure the correct workspace or backend is configured before executing the command.
- Consider using `terraform plan -destroy` to preview what will be destroyed before running the actual command.

## Example
```bash
terraform destroy -auto-approve
```
This command will destroy all resources managed by the current Terraform configuration without requiring confirmation.

## Best Practices
- Always backup your state file before destroying resources.
- Use workspaces to separate environments (e.g., `development`, `staging`, `production`).
- Use `terraform plan -destroy` to preview what will be destroyed before proceeding.

## Related Commands
- `terraform apply`: Creates or updates resources as specified in the configuration files.
- `terraform plan -destroy`: Generates a destroy plan without applying it.

