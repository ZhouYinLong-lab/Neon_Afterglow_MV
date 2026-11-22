const fs = require('fs');

const sampleRate = 44100;
const duration = 180;
const totalSamples = sampleRate * duration;
const bpm = 105;
const beat = 60 / bpm;
const bar = beat * 4;
const TAU = Math.PI * 2;
let seed = 20261122;
const random = () => {
  seed = (1664525 * seed + 1013904223) >>> 0;
  return seed / 0x100000000;
};

const note = (midi) => 440 * Math.pow(2, (midi - 69) / 12);
const saw = (phase) => 2 * (phase - Math.floor(phase + 0.5));
const square = (phase) => (phase - Math.floor(phase) < 0.5 ? 1 : -1);
const tri = (phase) => 1 - 4 * Math.abs(Math.round(phase) - phase);
const pulse = (time, start, length, attack = 0.008, release = 0.08) => {
  const x = time - start;
  if (x < 0 || x >= length) return 0;
  const a = Math.min(1, x / attack);
  const r = Math.min(1, (length - x) / release);
  return a * r;
};
const phase = (freq, time) => (freq * time) % 1;

const chords = [
  [57, 60, 64], // Am
  [53, 57, 60], // F
  [48, 52, 55], // C
  [55, 59, 62], // G
];
const bassPattern = [0, 0, 7, 0, 3, 0, 7, 10];
const leadPattern = [
  0, 3, 7, 10, 7, 3, 0, -2,
  0, 3, 7, 12, 10, 7, 3, 0,
];

const left = new Float32Array(totalSamples);
const right = new Float32Array(totalSamples);

for (let i = 0; i < totalSamples; i++) {
  const t = i / sampleRate;
  const beatIndex = Math.floor(t / beat);
  const beatPhase = (t % beat) / beat;
  const barIndex = Math.floor(t / bar);
  const section = t < 20 ? 0 : t < 55 ? 1 : t < 75 ? 2 : t < 105 ? 3 : t < 135 ? 4 : t < 170 ? 5 : 6;
  const energy = [0.25, 0.45, 0.7, 0.18, 0.78, 1.0, 0.22][section];
  const chord = chords[barIndex % chords.length];
  let l = 0;
  let r = 0;

  // Wide, slowly moving pad.
  const padLevel = 0.055 + energy * 0.035;
  for (let c = 0; c < chord.length; c++) {
    const f = note(chord[c] + 12);
    const p1 = phase(f * 0.997, t);
    const p2 = phase(f * 1.003, t);
    const voice = (saw(p1) + saw(p2)) * 0.5;
    const pan = [-0.65, 0, 0.65][c];
    l += voice * padLevel * (1 - pan) * 0.5;
    r += voice * padLevel * (1 + pan) * 0.5;
  }

  // Eighth-note synth bass.
  if (energy > 0.3) {
    const eighth = beat / 2;
    const step = Math.floor(t / eighth);
    const within = t - step * eighth;
    const bassNote = chord[0] - 24 + bassPattern[step % bassPattern.length];
    const f = note(bassNote);
    const env = Math.exp(-within * 11) * (0.42 + energy * 0.16);
    const bass = (Math.sin(TAU * f * within) + 0.3 * saw(phase(f * 2, within))) * env;
    l += bass * 0.42;
    r += bass * 0.42;
  }

  // Arpeggiator: quiet during intro/break, bright during drops.
  if (energy > 0.55) {
    const sixteenth = beat / 4;
    const step = Math.floor(t / sixteenth);
    const within = t - step * sixteenth;
    const arpMidi = chord[step % 3] + 24 + [0, 12, 7, 12][step % 4];
    const f = note(arpMidi);
    const env = Math.exp(-within * 19) * 0.12 * energy;
    const arp = (square(phase(f, within)) + 0.4 * saw(phase(f * 2, within))) * env;
    l += arp * 0.75;
    r += arp * 0.75;
  }

  // Lead hook in the two main drops.
  if (section === 2 || section === 5) {
    const eighth = beat / 2;
    const step = Math.floor(t / eighth);
    const within = t - step * eighth;
    const midi = chord[1] + 12 + leadPattern[step % leadPattern.length];
    const f = note(midi);
    const env = pulse(within, 0, eighth * 0.9, 0.012, 0.12) * 0.12 * energy;
    const lead = (tri(phase(f, within)) + 0.35 * square(phase(f * 2, within))) * env;
    const pan = Math.sin(t * 0.55) * 0.35;
    l += lead * (1 - pan);
    r += lead * (1 + pan);
  }

  // Kick and snare.
  const beatInBar = beatIndex % 4;
  const kick = Math.exp(-beatPhase * 18) * (0.38 + energy * 0.2) * (energy > 0.3 ? 1 : 0.3);
  const kickBody = Math.sin(TAU * (58 - 28 * Math.min(1, beatPhase)) * beatPhase) * kick;
  l += kickBody;
  r += kickBody;
  if (beatInBar === 1 || beatInBar === 3) {
    const snare = (random() * 2 - 1) * Math.exp(-beatPhase * 24) * 0.15 * energy;
    l += snare;
    r += snare;
  }

  // Hi-hat pulse.
  if (energy > 0.35 && beatPhase < 0.09) {
    const hat = (random() * 2 - 1) * Math.exp(-beatPhase * 50) * 0.045 * energy;
    l += hat;
    r += hat;
  }

  // Section transitions: filtered-noise risers before drops.
  const transition = [55, 105, 135, 170].find((x) => t >= x - 2 && t < x);
  if (transition !== undefined) {
    const x = (t - (transition - 2)) / 2;
    const riser = (random() * 2 - 1) * x * x * 0.04;
    l += riser;
    r += riser;
  }

  // Stereo delay-like widening from the pad and gentle master fade.
  const fadeIn = Math.min(1, t / 2);
  const fadeOut = Math.min(1, (duration - t) / 3);
  const gain = fadeIn * fadeOut;
  left[i] = Math.tanh(l * 0.9) * gain;
  right[i] = Math.tanh(r * 0.9) * gain;
}

const wav = Buffer.alloc(44 + totalSamples * 4);
wav.write('RIFF', 0);
wav.writeUInt32LE(36 + totalSamples * 4, 4);
wav.write('WAVE', 8);
wav.write('fmt ', 12);
wav.writeUInt32LE(16, 16);
wav.writeUInt16LE(1, 20);
wav.writeUInt16LE(2, 22);
wav.writeUInt32LE(sampleRate, 24);
wav.writeUInt32LE(sampleRate * 4, 28);
wav.writeUInt16LE(4, 32);
wav.writeUInt16LE(16, 34);
wav.write('data', 36);
wav.writeUInt32LE(totalSamples * 4, 40);

for (let i = 0, offset = 44; i < totalSamples; i++, offset += 4) {
  wav.writeInt16LE(Math.max(-32768, Math.min(32767, Math.round(left[i] * 32767))), offset);
  wav.writeInt16LE(Math.max(-32768, Math.min(32767, Math.round(right[i] * 32767))), offset + 2);
}

const out = process.argv[2] || 'neon-afterglow-synthwave.wav';
fs.writeFileSync(out, wav);
console.log(`Wrote ${out} (${duration}s, ${sampleRate}Hz stereo)`);
