# 🚀 GitOps Workflow using ArgoCD on Kubernetes

## 🎯 Objective
Implement GitOps by syncing Kubernetes deployment states directly from a Git repository using ArgoCD.

---

## 🧰 Tools Used
- **K3s** – lightweight Kubernetes distribution  
- **ArgoCD** – continuous delivery controller for Kubernetes  
- **GitHub** – source of truth for manifests  
- **Docker Hub** – container image registry  

---

## 📂 Project Structure

```
.
├── README.md
├── app
│   ├── Dockerfile
│   └── index.html
├── apps
│   └── guestbook
│       └── base
│           ├── deployment.yaml
│           ├── kustomization.yaml
│           └── service.yaml
└── argocd
    └── app-guestbook.yaml
```

---

## How It Works
1. You push code → GitHub Actions builds & pushes image to Docker Hub.  
2. GitHub Actions updates image tag in `deployment.yaml` → commits to Git.  
3. ArgoCD detects the manifest change → syncs and redeploys automatically.  
4. K3s runs the updated app instantly.  

---

## Setup Steps
### 1. Install K3s
```
curl -sfL https://get.k3s.io | sh -
```

### 2. Install ArgoCD
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 3. Expose ArgoCD
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Open https://localhost:8080, login as admin (get password from secret).

### 4. Apply ArgoCD Application
```
kubectl apply -f argocd/app-guestbook.yaml -n argocd
```

### 5. Access App
```
kubectl get svc guestbook -n default
```
→ Open in browser: http://<NODE_IP>:30080

---

## GitHub Secrets Required
```
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
```
Set these in:
GitHub → Settings → Secrets and Variables → Actions

---

## Tip

To upgrade app:
```
# make code change
git add . && git commit -m "update app" && git push
```
GitHub Actions will handle the rest automatically

---

**Note**
```
| Step | What it shows                          | Command                           |
| ---- | -------------------------------------- | --------------------------------- |
| 1    | Where Kubernetes node runs             | `kubectl get nodes -o wide`       |
| 2    | On which node your Pod runs            | `kubectl get pods -o wide`        |
| 3    | Which port your app is exposed on      | `kubectl get svc`                 |
| 4    | Open in browser using node IP and port | e.g., `http://172.18.43.47:30080` |
```