#!/usr/bin/env python3
"""Original temporary vector assets. Standard-library-only, deterministic generation.
Run from any directory: python3 tools/generate_actor_atlases.py
Rows: idle, move, attack, hit, death; each has se, sw, ne, nw. Four columns.
Cell 80x80, feet origin (40,68), standing body approximately 48 reference pixels.
"""
from pathlib import Path
from xml.sax.saxutils import escape
ROOT = Path(__file__).resolve().parents[1]
STATES = ('idle', 'move', 'attack', 'hit', 'death')
DIRECTIONS = ('se', 'sw', 'ne', 'nw')

def figure(kind, state, direction, frame):
    hero = kind == 'hero'
    cloth, light, dark = ('#247c92','#72dbe0','#164451') if hero else ('#a84751','#f69779','#512b43')
    metal, skin = ('#f4ce76','#efd4b3') if hero else ('#c9b4d9','#cdb9dc')
    back = direction in ('ne','nw')
    outline = '#172332'
    # Mirror only within front/back pairs; rear sprites have their own body details.
    mirror = 'translate(80 0) scale(-1 1)' if direction in ('sw','nw') else ''
    bob = [0,-1,0,1][frame] if state in ('idle','move') else 0
    lean = [0,-3,4,0][frame] if state=='attack' else ([0,-4,-2,0][frame] if state=='hit' else 0)
    if state=='death': bob,lean=[0,0,0,0][frame],[0,-4,-7,0][frame]
    parts=[f'<g transform="{mirror}" stroke="{outline}" stroke-width="1.5" stroke-linejoin="round" stroke-linecap="round">']
    if state=='death' and frame==3:
        parts += [f'<path d="M22 59Q35 51 47 58L57 64L50 68L27 67Z" fill="{cloth}"/>',
                  f'<ellipse cx="24" cy="61" rx="8" ry="6" fill="{metal if hero else dark}"/>',
                  '<path d="M21 61L26 63M48 64L61 66M47 61L59 62" fill="none"/>',
                  f'<path d="M30 68L53 70" stroke="{light}"/>']
    else:
        stride=[0,5,0,-5][frame] if state=='move' else 0
        parts += [f'<path d="M33 51L{32-stride} 65L{27-stride} 68L{36-stride} 68L40 52M41 51L{45+stride} 64L{44+stride} 68L{53+stride} 68L48 50" fill="{dark}"/>']
        transform = f'translate({lean} {bob})'
        if state == 'death':
            transform = f'translate(0 68) scale(1 {[1,.8,.5,1][frame]}) translate({lean} -68)'
        parts += [f'<g transform="{transform}">']
        # Torso and cape remain distinguishable by silhouette, not only hue.
        if hero:
            parts += [f'<path d="M30 33L26 57L39 61L51 56L48 33Z" fill="{dark}"/>',
                      f'<path d="M30 34L45 33L50 50L41 58L30 51Z" fill="{cloth}"/>',
                      f'<path d="M30 36L39 40L47 35L45 47L34 49Z" fill="{light}"/>']
        else:
            parts += [f'<path d="M29 35L45 32L51 57L43 54L38 61L32 55L26 58Z" fill="{cloth}"/>',
                      f'<path d="M30 39L46 35M29 48L47 44" stroke="{light}"/>']
        parts += [f'<path d="M28 37L22 49L27 52L34 39" fill="{metal if hero else dark}"/>']
        if back:
            parts += [f'<path d="M33 39L42 37L43 48L36 51Z" fill="{metal}"/>']
        else:
            parts += [f'<path d="M33 49L47 47" stroke="{metal}" stroke-width="3"/>']
        # Head: helmet versus pointed hood.
        if hero:
            parts += [f'<path d="M31 32L29 25Q32 17 42 21L48 27L45 35L35 36Z" fill="{metal}"/>']
            if not back:
                parts += [f'<path d="M37 25L47 27L45 32L38 31Z" fill="{outline}"/>', '<path d="M41 28L45 29" stroke="#fff1cb"/>']
            else: parts += [f'<path d="M34 23L35 32" stroke="{dark}" stroke-width="3"/>']
        else:
            parts += [f'<path d="M28 33L30 25L39 20L48 27L49 35L40 38Z" fill="{dark}"/>']
            if not back:
                parts += [f'<path d="M37 27L46 28L45 33L39 34Z" fill="{skin}"/>','<path d="M40 29L44 30"/>']
            else: parts += [f'<path d="M35 25L39 34" stroke="{light}"/>']
        reach=[0,-6,15,3][frame] if state=='attack' else 0
        parts += [f'<path d="M45 37L{53+reach} 44L{50+reach} 49L43 43" fill="{metal if hero else dark}"/>']
        if hero:
            parts += [f'<path d="M{51+reach} 46L{54+reach} 29L{57+reach} 25L{58+reach} 30L{54+reach} 47Z" fill="#deedf2"/>',f'<path d="M{49+reach} 44L{57+reach} 46" stroke="{metal}" stroke-width="3"/>']
        else:
            parts += [f'<path d="M{51+reach} 46L{57+reach} 35L{59+reach} 38L{54+reach} 49Z" fill="#deedf2"/>']
        if state=='attack' and frame==2:
            parts += [f'<path d="M60 19Q77 32 70 52" fill="none" stroke="{light}" stroke-width="3"/>']
        if state=='hit' and frame in (1,2):
            parts += ['<path d="M20 25L24 30M51 18L48 24M15 38L21 39" stroke="#fff4cf" stroke-width="3"/>']
        parts += ['</g>']
    parts += ['</g>']
    return ''.join(parts)

def main():
    target=ROOT/'assets/actors'
    target.mkdir(parents=True,exist_ok=True)
    for kind in ('hero','enemy'):
        out=['<svg xmlns="http://www.w3.org/2000/svg" width="320" height="1600" viewBox="0 0 320 1600">',f'<title>{escape(kind)} temporary animation atlas</title>']
        for si,state in enumerate(STATES):
            for di,direction in enumerate(DIRECTIONS):
                row=si*4+di
                for frame in range(4):
                    out.append(f'<g transform="translate({frame*80} {row*80})">'+figure(kind,state,direction,frame)+'</g>')
        out.append('</svg>')
        (target/f'{kind}_atlas.svg').write_text('\n'.join(out)+'\n')
if __name__=='__main__':main()
