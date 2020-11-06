using YAML
using Dates

cd("$(homedir())/Dropbox/Webpage/markaguiar.github.io/src/")

src_dir = "."
root_dir = ".."
subpage_dir = "citation"
subpage_path = joinpath(root_dir, subpage_dir)

header_pubs = """---
layout: single
author_profile: true
toc: true
toc_label: Papers
title: Research
canonical_url: "https://markaguiar.github.io/"
---

"""

@info "Reading papers database"

papers = reverse(YAML.load(open(joinpath(src_dir, "papers.yaml"))))

link_str(a, b; pre="", post="") = pre * "[$a]($b)" * post

bibtex(s) = "\t" * join(split(s, "\n"), "\n\t\t")

permalink(s) = "/" * subpage_dir * "/" * s

@info "Generating research page"

open(joinpath(root_dir, "index.md"), "w") do io
    write(io, header_pubs)
    write(io, "# Working papers\n")
    for p in papers
        if !p["published"] && p["show_on_website"]
            write(io, "* " * link_str(p["title"],  permalink(p["permalink"]), post="\n\n"))
            write(io, "    " * p["citation"] * "\n")
            lst = String[]
            push!(lst, link_str("PDF", p["PDF"]))
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
                join(io, lst, " -- ") 
            end 
            write(io, "\n")
        end
    end

    write(io, "\n\n")
    write(io, "# Publications\n\n")
#    write(io, "[BibTeX file](http://markaguiar.github.io/files/ref.bib)\n\n")

    for p in papers
        if p["published"] && p["show_on_website"]
            write(io, "* " * link_str(p["title"],  permalink(p["permalink"]), post="\n\n"))
            write(io, "    " * p["citation"] * "\n")
            lst = String[]
            push!(lst, link_str("PDF", p["PDF"]))
            push!(lst, link_str("Journal link", p["journal"]))
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
            end 
            push!(lst, link_str("BibTeX and abstract", permalink(p["permalink"])))
            join(io, lst, " -- ")
            write(io, "\n\n")
        end
    end
end



# Generating the subpages 

function header_subpage(title, permalink)
    return "---\nlayout: single \nauthor_profile: true \ntitle: $title \npermalink: $permalink\nexclude: true\n---\n\n"
end 

@info "Generating subpages"

for p in papers
    if  p["show_on_website"] #&& p["published"]
        @info "   -> " * p["title"]
        file = joinpath(subpage_path, p["permalink"] * ".md")
        open(file, "w") do io
            write(io, header_subpage(p["title"], permalink(p["permalink"])))
            lst = String[]
            
            push!(lst, link_str("PDF", p["PDF"]))
            if   p["published"]
                push!(lst, link_str("Journal link", p["journal"]))
            end
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
            end 
            join(io, lst, " -- ")

            write(io, "\n#### Citation\n\n")
            write(io, p["citation"] * "\n\n")
            if haskey(p, "abstract")
                write(io, "#### Abstract\n\n")
                write(io, p["abstract"])
            end 
            if   p["published"]
                write(io, "BibTeX Cite\n\n")
                write(io, bibtex(p["bibtex"]))
            end
        end
    end
end 


# # Generating the CV 

# @info "Generating CV"

# cv_header = """---
# layout: page
# title: CV
# permalink: /cv/
# ---
# """

# open(joinpath(root_dir, "01_cv.md"), "w") do io
#     write(io, cv_header)
#     write(io, "\n")
#     write(io, "# Manuel Amador \n\n")
#     write(io, "*updated on " * string(Date(now())) * "* \n\n")
#     write(io, read(joinpath(src_dir, "cv_part1.md"), String))
#     write(io, "\n")
#     write(io, "## Publications\n\n")
#     for p in papers
#         p["published"] && write(io, "- " * p["citation"] * "\n\n")
#     end
#     write(io, "## Working Papers\n\n")
#     for p in papers
#         !p["published"] && write(io, "- " * p["citation"] * "\n\n")
#     end
#     write(io, read(joinpath(src_dir, "cv_part2.md"), String))
#     write(io, "\n")
# end

# @info "Done with CV"

