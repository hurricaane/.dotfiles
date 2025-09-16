function bw_unlock
    set -gx BW_SESSION (bw unlock --raw)
    if test -z "$BW_SESSION"
        echo "Échec du déverrouillage de Bitwarden."
        return 1
    else
        echo "Bitwarden déverrouillé. Variable BW_SESSION définie."
    end
end
