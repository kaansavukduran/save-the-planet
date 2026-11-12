"""Extract reviewed alpha spans, never assume a uniform source grid. MPL-2.0."""
from pathlib import Path
import json
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
registry={}
for source in ['CANONICAL','AGILITY']:
 meta=json.loads((ROOT/'assets/source'/f'{source}-PROVENANCE.json').read_text())
 for key,spec in meta['atlases'].items():
  if key.startswith('legacy'):continue
  image=Image.open(ROOT/'assets/source'/Path(spec['path']).name).convert('RGBA')
  registry[key]=[]
  rows=range(4) if key in ['canonical-rolls','agility-wolf','agility-owl'] else [0,1,2,3,4,6,9,10,13]
  for row in rows:
   line=[]
   for col,f in enumerate(spec['frames'][row]):
    b=f['bounds'];rect=f['rect'];scale=spec['scale'][row]
    cropped=Image.new('RGBA',(b[2]-b[0]+4,b[3]-b[1]+4))
    for y,x,n in f['runs']:
     cropped.paste(image.crop((rect[0]+x,rect[1]+y,rect[0]+x+n,rect[1]+y+1)),(x-b[0]+2,y-b[1]+2))
    # Retain full source resolution. Runtime nearest filtering and shared scale.
    name=f'{key}-{row}-{col}.png';cropped.save(ROOT/'assets/derived'/name)
    origin=f.get('origin',[f.get('anchor_x',(b[0]+b[2])/2),b[3]])
    line.append({'texture':'res://assets/derived/'+name,'offset':[(b[0]-origin[0]-2)*scale,(b[1]-origin[1]-2)*scale],'scale':scale})
   registry[key].append({'row':row,'frames':line})
(ROOT/'data/sprites.json').write_text(json.dumps(registry,separators=(',',':')))
print('Derived',sum(len(r['frames']) for rows in registry.values() for r in rows),'independent registered frames')
# Named foreground scenery uses the same reviewed alpha-run extraction.
spec=json.loads((ROOT/'assets/source/PARKOUR-PROVENANCE.json').read_text())
image=Image.open(ROOT/'assets/source/frontier-parkour.png').convert('RGBA')
for name,row,col in [('forest-arch',0,0),('pipe-arch',1,0),('log',2,1),('barrier',2,2),('rocks',2,3),('grass-left',3,0),('grass-right',3,1),('industrial-left',3,2),('industrial-right',3,3)]:
 f=spec['frames'][row][col];b=f['bounds'];rect=f['rect'];out=Image.new('RGBA',(b[2]-b[0]+4,b[3]-b[1]+4))
 for y,x,n in f['runs']:out.paste(image.crop((rect[0]+x,rect[1]+y,rect[0]+x+n,rect[1]+y+1)),(x-b[0]+2,y-b[1]+2))
 out.save(ROOT/'assets/derived'/f'prop-{name}.png')
print('Derived 9 named scenery props')
