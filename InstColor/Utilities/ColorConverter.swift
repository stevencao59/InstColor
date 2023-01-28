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

func getRgbCmyk(r: CGFloat, g: CGFloat, b: CGFloat) -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
    let rgbScale = 255.0
    let cmykScale = 100.0
    
    if r == 0 && g == 0 && b == 0 {
        return (c: 0, m: 0, y: 0, k: cmykScale)
    }
    
    // rgb [0,255] -> cmy [0,1]
    var c = 1 - r / rgbScale
    var m = 1 - g / rgbScale
    var y = 1 - b / rgbScale
    
    // extract out k [0, 1]
    let minCmy = min(c, m, y)
    c = (c - minCmy) / (1 - minCmy)
    m = (m - minCmy) / (1 - minCmy)
    y = (y - minCmy) / (1 - minCmy)
    let k = minCmy
    
    // rescale to the range [0,CMYK_SCALE]
    return (c: c * cmykScale, m: m * cmykScale, y: y * cmykScale, k: k * cmykScale)
}

func getCmykRgb(c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    let rgbScale = 255.0
    let cmykScale = 100.0
    
    let cc = c / cmykScale
    let cm = m / cmykScale
    let cy = y / cmykScale
    let ck = k / cmykScale
    
    let r = rgbScale - ((min(1.0, cc * (1.0 - ck) + ck)) * rgbScale)
    let g = rgbScale - ((min(1.0, cm * (1.0 - ck) + ck)) * rgbScale)
    let b = rgbScale - ((min(1.0, cy * (1.0 - ck) + ck)) * rgbScale)
    
    return (r, g, b)
}

func getRgbXyz(r: CGFloat, g: CGFloat, b: CGFloat) -> (x: CGFloat, y: CGFloat, z:CGFloat) {
    func transform(value: CGFloat) -> CGFloat {
        if value > 0.04045 {
            return pow((value + 0.055) / 1.055, 2.4)
        }
        
        return value / 12.92
    }
    
    let red = transform(value: r) * 100.0
    let green = transform(value: g) * 100.0
    let blue = transform(value: b) * 100.0
    
    let x = (red * 0.4124 + green * 0.3576 + blue * 0.1805).rounded(.toNearestOrEven)
    let y = (red * 0.2126 + green * 0.7152 + blue * 0.0722).rounded(.toNearestOrEven)
    let z = (red * 0.0193 + green * 0.1192 + blue * 0.9505).rounded(.toNearestOrEven)
    
    return (x, y, z)
}

func getRgbLab(r: CGFloat, g: CGFloat, b: CGFloat) -> (l: CGFloat, a: CGFloat, b:CGFloat) {
    let LAB_E: CGFloat = 0.008856
    let LAB_16_116: CGFloat = 0.1379310
    let LAB_K_116: CGFloat = 7.787036
    let LAB_X: CGFloat = 0.95047
    let LAB_Y: CGFloat = 1
    let LAB_Z: CGFloat = 1.08883
    
    func labCompand(_ v: CGFloat) -> CGFloat {
        return v > LAB_E ? pow(v, 1.0 / 3.0) : (LAB_K_116 * v) + LAB_16_116
    }
    
    func sRGBCompand(_ v: CGFloat) -> CGFloat {
        let absV = abs(v)
        let out = absV > 0.04045 ? pow((absV + 0.055) / 1.055, 2.4) : absV / 12.92
        return v > 0 ? out : -out
    }
    
    let R = sRGBCompand(r)
    let G = sRGBCompand(g)
    let B = sRGBCompand(b)
    let x: CGFloat = (R * 0.4124564) + (G * 0.3575761) + (B * 0.1804375)
    let y: CGFloat = (R * 0.2126729) + (G * 0.7151522) + (B * 0.0721750)
    let z: CGFloat = (R * 0.0193339) + (G * 0.1191920) + (B * 0.9503041)
    
    let fx = labCompand(x / LAB_X)
    let fy = labCompand(y / LAB_Y)
    let fz = labCompand(z / LAB_Z)
    return (
        l: 116 * fy - 16,
        a: 500 * (fx - fy),
        b: 200 * (fy - fz)
    )
}
