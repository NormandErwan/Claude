import json,sys,uuid,os,re
# usage: mk.py <cwd> <turns.json: [[user,assistant],...]> -> prints session id
cwd,turns=sys.argv[1],json.load(open(sys.argv[2]))
sid=str(uuid.uuid4()); d=os.path.expanduser('~/.claude/projects/'+re.sub(r'[^A-Za-z0-9]','-',cwd)); os.makedirs(d,exist_ok=True)
base=dict(isSidechain=False,userType='external',cwd=cwd,sessionId=sid,version='2.1.330')
p=None;out=[]
for i,(u,a) in enumerate(turns):
  for role,txt in (('user',u),('assistant',a)):
    k=str(uuid.uuid4()); ts=f'2026-11-22T15:{i:02d}:{0 if role=="user" else 30}.000Z'
    m={'role':'user','content':txt} if role=='user' else {'id':'msg_'+k[:8],'type':'message','role':'assistant','model':'claude-opus-5-5','content':[{'type':'text','text':txt}],'stop_reason':'end_turn','stop_sequence':None,'usage':{'input_tokens':0,'output_tokens':0}}
    out.append(dict(base,parentUuid=p,type=role,message=m,uuid=k,timestamp=ts)); p=k
open(f'{d}/{sid}.jsonl','w').write('\n'.join(json.dumps(x,ensure_ascii=False) for x in out)+'\n'); print(sid)
