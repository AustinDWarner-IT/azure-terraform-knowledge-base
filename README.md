# azure-terraform-knowledge-base
Documenting my Azure Terraform learning journey.


## 📌 Setting Up Terraform

### Installing Terraform
1. **Download Terraform** from the official website: [Terraform Downloads](https://www.terraform.io/downloads.html).
2. Extract the `terraform.exe` file to a directory of your choice.  
   Example: `C:\terraform`.

---

### Adding Terraform to System PATH (Windows)

To make sure you can run `terraform` commands from any directory, you need to add `terraform.exe` to your `PATH`.

#### ✅ Steps to Add Terraform to PATH
1. **Open System Environment Variables**:
   - Press `Windows Key` + `S` and type `Environment Variables`.
   - Click on **“Edit the system environment variables”**.

2. **Edit System Variables**:
   - Click on the **“Environment Variables...”** button.

3. **Find the `Path` Variable**:
   - Under **System variables**, scroll down and select `Path`.
   - Click **Edit**.

4. **Add New Path**:
   - Click **“New”** and add the path to the folder where you placed `terraform.exe`.
   - Example: `C:\terraform`.

5. **Click OK** on all the dialogs to save changes.

---

### Verifying Installation
1. Open a new Command Prompt or PowerShell window.
2. Run:
   ```powershell
   terraform version


terraform init        # Initialize Terraform in the current directory
terraform plan        # Create an execution plan
terraform apply       # Apply the changes required to reach the desired state
terraform destroy     # Destroy all resources managed by Terraform


