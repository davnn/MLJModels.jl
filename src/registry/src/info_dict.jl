# `info_dict` returns a dictionary of model traits which, after
# encoding, can be serializing to TOML file to create the "model
# registry". Not intended to be exposed to user. Note that `info` gets
# the list of traits from the registry but `info_dict` gets the list
# from MLJModelInterface.MODEL_TRAITS, which is larger when new traits are
# added but the registry is not yet updated.

info_dict(model::Model) = info_dict(typeof(model))

function info_dict(M::Type{<:Model})
    message = "$M has a bad trait declaration.\n"
    is_pure_julia(M) isa Bool ||
        error(message * "`is_pure_julia($M)` must return true or false")
    supports_weights(M) isa Bool ||
        error(message * "`supports_weights($M)` must return true, "*
              "false or missing. ")
    is_wrapper(M) isa Bool ||
        error(message * "`is_wrapper($M)` must return true, false. ")

    return LittleDict{Symbol,Any}(trait => eval(:($trait))(M)
                                  for trait in MLJModelInterface.MODEL_TRAITS)
end
