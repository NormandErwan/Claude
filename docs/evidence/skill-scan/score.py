import json,sys
for p in sys.argv[1:]:
    seq=[];cost=None;res="";inp=0;denied=[]
    for l in open(p):
        e=json.loads(l)
        if e.get("type")=="assistant":
            u=e["message"].get("usage",{}); inp+=u.get("input_tokens",0)+u.get("cache_read_input_tokens",0)+u.get("cache_creation_input_tokens",0)
            for c in e["message"]["content"]:
                if c.get("type")=="tool_use":
                    n=c["name"]; i=c["input"]
                    seq.append(f"Skill:{i.get('skill')}" if n=="Skill" else n+(":"+i.get("file_path","").split("/")[-1] if "file_path" in i else ""))
        if e.get("type")=="result": cost=e.get("total_cost_usd"); res=e.get("result",""); denied=e.get("permission_denials",[])
    print(p.split("/")[-2], "cost",cost,"input_tok",inp,"denied",len(denied)); print("  ", " > ".join(seq)); print("   result:",res[:200].replace("\n"," "))
