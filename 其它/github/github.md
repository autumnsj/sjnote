## 密钥登录github

## [Generating a new SSH key for a hardware security key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-for-a-hardware-security-key)

If you are using macOS or Linux, you may need to update your SSH client or install a new SSH client prior to generating a new SSH key. For more information, see "[Error: Unknown key type](https://docs.github.com/en/authentication/troubleshooting-ssh/error-unknown-key-type)."

1. Insert your hardware security key into your computer.

2. Open Git Bash.

3. Paste the text below, substituting in the email address for your account on GitHub.

   ```shell
   ssh-keygen -t ed25519-sk -C "YOUR_EMAIL"
   ```

   **Note:** If the command fails and you receive the error `invalid format` or `feature not supported,` you may be using a hardware security key that does not support the Ed25519 algorithm. Enter the following command instead.

   ```shell
    ssh-keygen -t ecdsa-sk -C "your_email@example.com"
   ```

4. When you are prompted, touch the button on your hardware security key.

5. When you are prompted to "Enter a file in which to save the key," press Enter to accept the default file location.

   ```shell
   > Enter a file in which to save the key (/c/Users/YOU/.ssh/id_ed25519_sk):[Press enter]
   ```

6. When you are prompted to type a passphrase, press **Enter**.

   ```shell
   > Enter passphrase (empty for no passphrase): [Type a passphrase]
   > Enter same passphrase again: [Type passphrase again]
   ```

7. Add the SSH public key to your account on GitHub. For more information, see "[Adding a new SSH key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)."
