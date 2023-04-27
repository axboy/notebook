# Git

## 命令对比

- 初始环境

  ![init](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/cdc8300cd2619cf60df884f8cafe2f93-60e445.png)

### merge和rebase的区别

- **不严谨的点：**
  1. 下面合并都是理想条件，没有冲突。
  2. 先修改的future，再修改的master，有兴趣的可以试试交叉修改。
  3. 应该是**feature**，不是**future**，这不是重点。。。

- 条件准备

  ![future/1211](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/a19088fde705c04091817b8b4bc05951-0637d4.png)

  ![all before](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/5245dd2c47c5357061f00111f57aec23-086563.png)

- git merge

  ```sh
  git merge future/1211 -m "merge 1211"
  ```

  ![merge result](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/c5c537bc44e33b734905f073257cc61c-815cba.png)

- git rebase

  ```sh
  git rebase future/1211
  ```

  ![rebase result](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/dc1ee9602a7c9022b0b1b83df69f64f4-4c9c84.png)

- 结论

  1. merge和rebase**对代码产生的影响是一样**
  2. merge是一次新的提交，一个合并的四边形，无冲突时是空内容提交，对master来说，master只提交了merge那一次
  3. rebase就是把future分之的commit在master重新提交一遍

- 建议
  1. 同分支rebase，不同分支merge
  2. 不明白就只用merge

### git diff ..和...的区别

```sh
# 比较以下3种diff
git diff future/1211 master   
git diff future/1211..master 
git diff future/1211...master
```

- 执行结果

  ![](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/8b1cdc9d8ec26b10f0685c51e8e8edff-95a8ee.png)

  ![..](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/2e7b8334acace802f3c5f1c1156d6fd0-aed8d6.png)

  ![...](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/083b11c5f32eb007c60320166c3995a3-50ad9b.png)

- 结论

  ![diff result](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202212/79edccf5eaf1cd3692c89c8f6142ee75-4d2124.png)

  1. **git diff future master**和**git diff future..master**是一样的，标识比较两个分支最后一次提交 **(5和12)**结果的差异。

  2. **git diff future...master**就是future和master的共同祖先 **(3)**，和master最新节点 **(5)**对比。


## 冷门操作

### 删除历史大文件

### 删除历史中的文件夹

参考自[StackOverflow(how to remove a folder and all its history)](https://stackoverflow.com/questions/32537051/how-to-remove-a-folder-and-all-its-history)

有一种情况是这样的，首次提交代码时没配置 _.gitignore_ ，误上传 _target, node_modules, dist_ 之类的文件夹，下面以node_modules为例：

```sh
# 删除历史中的文件夹
git filter-branch --tree-filter 'rm -rf node_modules' --prune-empty HEAD

# 更新忽略文件
echo node_modules/ >> .gitignore
git add .gitignore
git commit -m 'Removing some folder from git history'

# 强制提交
git push -f

# 其它用户更新
git pull --rebase

# 重置git，回收磁盘空间(选做)
git gc
```

