int n;
int ans=0;
int b[20];
int l[40];
int r[40];

int dfs(int x)
{
	int i;
	if(x==n)
	{
		++ans;
		return 0;
	}
	for(i=0;i<n;++i)
		if(!b[i]&&!l[i+x]&&!r[i-x+n-1])
		{
			b[i]=-1;
			l[i+x]=1;
			r[i-x+n-1]=1;
			dfs(x+1);
			b[i]=0;
			l[i+x]=0;
			r[i-x+n-1]=0;
		}
	return 0;
}

int main()
{
	scanf("%d",&n);
	if(n>16)
		printf("%d",-1);
	else
	{
		dfs(0);
		printf("%d",ans);
	}
	return 0;
}

