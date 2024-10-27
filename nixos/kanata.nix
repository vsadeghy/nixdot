{
  services.kanata = {
    enable = true;
    keyboards = {
      homerow = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          ;; Home row mods QWERTY
          ;; - when a home row mod activates tap, the home row mods are disabled
          ;;   while continuing to type rapidly
          ;; - tap-hold-release helps make the hold action more responsive
          ;; - pressing another key on the same half of the keyboard
          ;;   as the home row mod will activate an early tap action

          (defsrc
            a   s   d   f   j   k   l   ;
          ;;M   A   C   S   S   C   A   M
          ;; capsescape
          caps esc
          )
          (defvar
            ;; Note: consider using different time values for your different fingers.
            ;; For example, your pinkies might be slower to release keys and index
            ;; fingers faster.
            tap-time 200
            hold-time 150

            left-hand-keys (
              q w e r t
              a s d f g
              z x c v b
            )
            right-hand-keys (
              y u i o p
              h j k l ;
              n m , . /
            )
          )
          (deflayer base
            @a  @s  @d  @f  @j  @k  @l  @;
            esc grv
          )

          (deflayer nomods
            a   s   d   f   j   k   l   ;
            esc grv
          )
          (deffakekeys
            to-base (layer-switch base)
          )
          (defalias
            tap (multi
              (layer-switch nomods)
              (on-idle-fakekey to-base tap 20)
            )

            a (tap-hold-release-keys $tap-time $hold-time (multi a @tap) lmet $left-hand-keys)
            s (tap-hold-release-keys $tap-time $hold-time (multi s @tap) lalt $left-hand-keys)
            d (tap-hold-release-keys $tap-time $hold-time (multi d @tap) lctl $left-hand-keys)
            f (tap-hold-release-keys $tap-time $hold-time (multi f @tap) lsft $left-hand-keys)
            j (tap-hold-release-keys $tap-time $hold-time (multi j @tap) rsft $right-hand-keys)
            k (tap-hold-release-keys $tap-time $hold-time (multi k @tap) rctl $right-hand-keys)
            l (tap-hold-release-keys $tap-time $hold-time (multi l @tap) ralt $right-hand-keys)
            ; (tap-hold-release-keys $tap-time $hold-time (multi ; @tap) rmet $right-hand-keys)
          )
        '';
      };
    };
  };
}