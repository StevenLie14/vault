# Vault (HashiCorp Vault)

This repository contains files to build and run a HashiCorp Vault server using Docker.
## Quick start (local)

Requirements:
- Docker Engine
- Docker Compose (v2 or integrated with Docker CLI)

From the repository root:

1. Build and start the container:

```powershell
docker compose up -d --build
```

2. Visit the Vault UI at `http://localhost:8200`.

3. To stop and remove containers:

```powershell
docker compose down
```

---

## Initialization and Keys (via UI)

When Vault starts for the first time, it is in a **sealed state**.

1. Open the UI at [http://localhost:8200](http://localhost:8200).
2. You will be prompted to **Initialize Vault**.
3. Set the number of **key shares** (default 5) and **key threshold** (default 3).
4. Vault will generate:

   * **Unseal keys** (e.g., 5 keys)
   * **Initial root token**

⚠️ **Important**: Save the unseal keys and root token securely. You’ll need them later.

---

## Unsealing Vault (via UI)

After initialization or any restart, Vault must be unsealed:

1. On the UI login screen, enter an **unseal key** into the input box.
2. Repeat with the required number of keys (e.g., 3 of 5).
3. Once threshold is met, Vault becomes **unsealed**.
4. Log in with the **root token**.

---

## Adding a User and Policy (via UI)

1. In the sidebar, go to **Access → Auth Methods** → enable **Userpass**.

2. Create a user (e.g., `exampleuser` / `examplepass`).

3. Go to **Access → Policies → Create ACL Policy**.

4. Example policy (`cicd-policy`):

   ```hcl
   path "kv/data/*" {
        capabilities = ["read"]
    }
   ```

5. Create a user and attach the policy:

   ```bash
   vault write auth/userpass/users/username password="password" policies="cicd-policy"
   ```

Now the new user can log in via the UI using the **userpass** method and will have access according to `cicd-policy`.

---

## Policies for CI/CD

* In CI/CD pipelines (e.g., GitHub Actions), it’s common to create **dedicated Vault users** with policies limited to only the secrets they need.
* Example: a `cicd-policy` that only grants read access to `secret/cicd/*`.
* This way, if a token or password leaks, exposure is limited.

💡 Best practice: **never use the root token in CI/CD**, always create a scoped policy.

---

