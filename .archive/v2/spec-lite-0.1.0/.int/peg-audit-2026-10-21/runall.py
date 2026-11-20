import os,sys; os.environ['G']=sys.argv[1]
import summ
mode=sys.argv[2] if len(sys.argv)>2 else 'block-shared'
cases=open(os.environ.get('C','cases.txt')).read().split('### ')[1:]
for c in cases:
    name,_,body=c.partition('\n')
    print('### '+name); print(body.rstrip('\n')); print('-->'); print(summ.summarize(body,mode)); print()
