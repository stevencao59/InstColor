//
//  ColorConverter.swift
//  InstColor
//
//  Created by Lei Cao on 11/8/22.
//

import Foundation

func v(m1: CGFloat, m2: CGFloat, hue: CGFloat) -> CGFloat {
    let hue_ = hue %% 1.0
    if hue_ < (1.0 / 6.0) {
        return m1 + (m2 - m1) * hue_ * 6.0
    }
    if hue_ < 0.5 {
        return m2
    }
    if hue_ < 2.0 / 3.0 {
        return m1 + (m2 - m1) * (2.0 / 3.0 - hue_) * 6.0
    }
    return m1
}

func getHlsRgb(h: CGFloat, l: CGFloat, s: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    var m1 = 0.0
    var m2 = 0.0

    if s == 0.0 {
        return (r: l, g: l, b: l)
    }
    if l <= 0.5 {
        m2 = l * (1.0 + s)
    } else {
        m2 = l + s - (l * s)
    }
    m1 = 2.0 * l - m2

    return(v(m1: m1, m2: m2, hue: h + (1.0 / 3.0)), v(m1: m1, m2: m2, hue: h), v(m1: m1, m2: m2, hue: h - (1.0/3.0)))
}

func getRgbHls(r: CGFloat, g: CGFloat, b: CGFloat) -> (h:CGFloat, l:CGFloat, s:CGFloat) {
    let maxC = max(r, g, b)
    let minC = min(r, g, b)
    let l = (minC + maxC) / 2.0
    
    if minC == maxC {
        return (h: 0.0, l: l, s: 0.0)
    }
    
    var s = 0.0
    if l <= 0.5 {
        s = (maxC - minC) / (maxC + minC)
    } else {
        s = (maxC - minC) / (2.0 - maxC - minC)
    }
    
    let rc = (maxC - r) / (maxC - minC)
    let gc = (maxC - g) / (maxC - minC)
    let bc = (maxC - b) / (maxC - minC)

    var h = 0.0
    if r == maxC {
        h = bc - gc
    } else if g == maxC {
        h = 2.0 + rc - bc
    } else {
        h = 4.0 + gc - rc
    }
    
    h = (h / 6.0) %% 1.0
    
    return (h: h, l: l, s: s)
}

func getRgbHsv(r: CGFloat, g: CGFloat, b: CGFloat) -> (h:CGFloat, s:CGFloat, v:CGFloat) {
    let maxC = max(r, g, b)
    let minC = min(r, g, b)
    let v = maxC
    
    if minC == maxC {
        return (h: 0.0, s: 0.0, v: v)
    }
    
    let s = (maxC - minC) / maxC
    let rc = (maxC - r) / (maxC - minC)
    let gc = (maxC - g) / (maxC - minC)
    let bc = (maxC - b) / (maxC - minC)

    var h = 0.0
    if r == maxC {
        h = bc - gc
    } else if g == maxC {
        h = 2.0 + rc - bc
    } else {
        h = 4.0 + gc - rc
    }
    
    h = (h / 6.0) %% 1.0
    
    return (h: h, s: s, v: v)
}

func getHsvRgb(h: CGFloat, s: CGFloat, v: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    if s == 0 { return (r: v, g: v, b: v) } // Achromatic grey
    
    var i = Int(h * 6.0)
    let f = (h * 6.0) - CGFloat(i)
    let p = v * (1.0 - s)
    let q = v * (1.0 - s*f)
    let t = v * (1.0 - s * (1.0 - f))
    i = i % 6
    
    switch(i) {
    case 0:
        return (r: v, g: t, b: p)
    case 1:
        return (r: q, g: v, b: p)
    case 2:
        return (r: p, g: v, b: t)
    case 3:
        return (r: p, g: q, b: v)
    case 4:
        return (r: t, g: p, b: v)
    default:
        return (r: v, g: p, b: q)
    }
}
